//
//  GarlicWebview.swift
//  GarlicWebviewTest
//
//  Created by TeamTapas on 17/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import Foundation
import UIKit
import WebKit

@objc
public protocol GarlicWebviewProtocol: class {
    @objc func onReceivedError(message: String)
    @objc func onPageStarted(url: String)
    @objc func onPageFinished(url: String)
    @objc func onShow()
    @objc func onClose()
}

class GarlicWebviewOptions {
    public var marginLeft : CGFloat
    public var marginRight : CGFloat
    public var marginTop : CGFloat
    public var marginBottom : CGFloat
    public var useFixedRatio : Bool
    public var ratioWidth : Int
    public var ratioHeight : Int
    
    public init(marginLeft: CGFloat, marginRight: CGFloat, marginTop: CGFloat, marginBottom: CGFloat) {
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.useFixedRatio = false;
        self.ratioWidth = 0
        self.ratioHeight = 0
    }
    public init() {
        self.marginLeft = 0;
        self.marginRight = 0;
        self.marginTop = 0;
        self.marginBottom = 0;
        self.useFixedRatio = false;
        self.ratioWidth = 0
        self.ratioHeight = 0
    }
    
    public func SetMargins(marginLeft: CGFloat, marginRight: CGFloat, marginTop: CGFloat, marginBottom: CGFloat) {
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
    }
    
    public func SetFixedRatio(ratioWidth: Int, ratioHeight: Int) {
        self.useFixedRatio = true
        self.ratioWidth = ratioWidth
        self.ratioHeight = ratioHeight
    }
    
    public func UnsetFixedRatio() {
        self.useFixedRatio = false
        self.ratioWidth = 0
        self.ratioHeight = 0
    }
}

@objc
public class GarlicWebviewController: NSObject {
    static let shared = GarlicWebviewController()
    //Using pt over px for convenience.
    static let DEFAULT_MARGIN_PT = CGFloat(30)
    static let CLOSE_BUTTON_SIZE_PT = CGFloat(50)
    
    var garlicDelegate: GarlicWebviewProtocol?
    var webViewDelegate: GarlicWebviewDelegate!
    var dimView: UIView!
    var webView: WKWebView!
    var closeButton: UIButton!
    let webviewOptions: GarlicWebviewOptions!
    
    override init() {
        self.webviewOptions = GarlicWebviewOptions()
        super.init()
        let defaultMarginPx = GarlicUtils.PointToPx(pt: GarlicWebviewController.DEFAULT_MARGIN_PT)
        self.webviewOptions.marginLeft = defaultMarginPx
        self.webviewOptions.marginRight = defaultMarginPx
        self.webviewOptions.marginTop = defaultMarginPx
        self.webviewOptions.marginBottom = defaultMarginPx
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc public static func GetInstance() -> GarlicWebviewController {
        return shared
    }
    
    @objc public func Initialize(parentUIView: UIView, garlicDelegate: GarlicWebviewProtocol) {
        if(webView != nil) {
            //print("WebView Already Initialized!")
            return
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GarlicWebviewController.onRotate),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        // Add Dim view. Using UIButton so that inputs will be never forwarded to root view controller!
        dimView = UIButton(frame: UIScreen.main.bounds)
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimView.isExclusiveTouch = true
        dimView.isUserInteractionEnabled = true
        dimView.isHidden = true
        parentUIView.addSubview(dimView)
        
        let webConfiguration = WKWebViewConfiguration()
        self.garlicDelegate = garlicDelegate
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webViewDelegate = GarlicWebviewDelegate(parent: self)
        webView.uiDelegate = webViewDelegate
        webView.navigationDelegate = webViewDelegate
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isHidden = true
        parentUIView.addSubview(webView)
        
        let bundle = Bundle(for: type(of: self))
        let buttonSize = GarlicWebviewController.CLOSE_BUTTON_SIZE_PT
        let buttonImage = UIImage(named: "exit_webview", in: bundle, compatibleWith: nil) as UIImage?
        closeButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        closeButton.frame = CGRect.init(x: webView.frame.maxX - buttonSize / 2,
            y: webView.frame.minY - buttonSize / 2,
            width: buttonSize,
            height: buttonSize)
        closeButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        closeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        closeButton.setImage(buttonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
        closeButton.isHidden = true
        parentUIView.addSubview(closeButton)
    }
    
    @objc func onRotate() {
        if webView != nil {
            self.RefreshLayout()
            //print("Rotated! webview frame: " + webView.frame.debugDescription + ", closeButton frame: " + closeButton.frame.debugDescription)
        }
    }
    
    @objc func onClickClose(sender: UIButton!) {
        self.Close()
    }
    
    @objc public func Show(url: String) {
        if(webView == nil) {
            print("WebView NOT initialized!")
            return
        }
        
        self.RefreshLayout()
        dimView.isHidden = false
        webView.isHidden = false
        closeButton.isHidden = false
        garlicDelegate?.onShow()
        
        let myURL = URL(string:url)
        var myRequest = URLRequest(url: myURL!)
        myRequest.httpShouldHandleCookies = false
        webView.load(myRequest)
    }
    
    @objc public func IsShowing() -> Bool{
        if(webView == nil) {
            print("WebView NOT initialized!")
            return false
        }
        return !webView.isHidden
    }
    
    @objc public func Close() {
        if(webView == nil) {
            print("Close() / WebView NOT initialized!")
            return
        }
        closeButton.isHidden = true
        webView.isHidden = true
        dimView.isHidden = true;
        garlicDelegate?.onClose()
        webView.stopLoading()
        webView.load(URLRequest(url: URL(string:"about:blank")!))
        ClearCache()
    }
    
    @objc public func Dispose() {
        if(webView == nil) {
            print("Dispose() / WebView NOT initialized!")
            return
        }
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.stopLoading()
        webView.removeFromSuperview()
        closeButton.removeFromSuperview()
        dimView.removeFromSuperview()
        
        webView = nil
        dimView = nil
        closeButton = nil
        webViewDelegate = nil
        garlicDelegate = nil
    }
    
    @objc public func SetFixedRatio(width: Int, height: Int) {
        webviewOptions.useFixedRatio = true
        webviewOptions.ratioWidth = width
        webviewOptions.ratioHeight = height
    }
    
    @objc public func SetMargins(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        webviewOptions.marginLeft = left
        webviewOptions.marginRight = right
        webviewOptions.marginTop = top
        webviewOptions.marginBottom = bottom
    }
    
    @objc public func UnsetFixedRatio() {
        webviewOptions.useFixedRatio = false
        webviewOptions.ratioWidth = 0
        webviewOptions.ratioHeight = 0
    }
    
    private func RefreshLayout() {
        dimView.frame = UIScreen.main.bounds
        
        let parentUIView = webView.superview!
        let originalFrame = parentUIView.frame
        let safeArea = self.GetSafeArea(parentUIView: parentUIView)
        var marginedFrame =  GetMarginedFrame(originalFrame: originalFrame, safeAreaBound: safeArea,
                                          left: GarlicUtils.PxToPoint(px: webviewOptions.marginLeft),                                          
                                          right: GarlicUtils.PxToPoint(px: webviewOptions.marginRight),
                                          top: GarlicUtils.PxToPoint(px: webviewOptions.marginTop),
                                          bottom: GarlicUtils.PxToPoint(px: webviewOptions.marginBottom))
        if(webviewOptions.useFixedRatio) {
            let ratioRate = CGFloat(webviewOptions.ratioWidth) / CGFloat(webviewOptions.ratioHeight)
            if(safeArea.width > safeArea.height) {
                //landscape mode
                //keep height, resize width
                let targetWidth = marginedFrame.height * ratioRate
                let targetInset = (marginedFrame.width - targetWidth) / 2.0
                marginedFrame = marginedFrame.insetBy(dx: targetInset, dy: 0)
            }
            else {
                //portrait mode
                //keep width, resize height
                let targetHeight = marginedFrame.width / ratioRate
                let targetInset = (marginedFrame.height - targetHeight) / 2.0
                marginedFrame = marginedFrame.insetBy(dx: 0, dy: targetInset)
            }
        }
        //print("w / h : " + (marginedFrame.width / marginedFrame.height).description)
        webView.frame = marginedFrame
        let buttonSize = GarlicWebviewController.CLOSE_BUTTON_SIZE_PT
        closeButton.frame = CGRect.init(x: webView.frame.maxX - buttonSize / 2,
                                        y: webView.frame.minY - buttonSize / 2,
                                        width: buttonSize,
                                        height: buttonSize)
    }
    
    private func GetMarginedFrame(originalFrame: CGRect, safeAreaBound: CGRect, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) -> CGRect{
        var frame = originalFrame
        frame.size.width = safeAreaBound.size.width - (left + right)
        frame.size.height = (safeAreaBound.size.height) - (top + bottom)
        frame.origin.x = safeAreaBound.origin.x + left
        frame.origin.y = safeAreaBound.origin.y + top
        return frame
    }
    
    private func GetSafeArea(parentUIView: UIView) -> CGRect{
        var safeAreaFrame = CGRect.zero
        if #available(iOS 11.0, *) {
            let safeAreaInsets = parentUIView.safeAreaInsets
            safeAreaFrame = CGRect.init(x: safeAreaInsets.left,
                                        y: safeAreaInsets.top,
                                        width: parentUIView.frame.size.width - safeAreaInsets.left - safeAreaInsets.right,
                                        height: parentUIView.frame.size.height - safeAreaInsets.top - safeAreaInsets.bottom)
        }
        else {
            safeAreaFrame = parentUIView.frame;
        }
        return safeAreaFrame
    }
    
    private func ClearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        }
        else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    internal class GarlicWebviewDelegate : NSObject, WKNavigationDelegate, WKUIDelegate {
        weak var parent: GarlicWebviewController?
        init (parent: GarlicWebviewController) {
            self.parent = parent
        }
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if(webView.isHidden) {
                return
            }
            let url = webView.url?.absoluteString ?? ""
            parent?.garlicDelegate?.onPageFinished(url: url)
            print("WebView content load done / OnPageFinished")
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if(webView.isHidden) {
                return
            }
            let url = webView.url?.absoluteString ?? ""
            parent?.garlicDelegate?.onPageStarted(url: url)
            print("WebView content load start / OnPageStarted")
        }
        
        public func webView(_ webView: WKWebView, didFail: WKNavigation!, withError: Error) {
            if(webView.isHidden) {
                return
            }
            parent?.garlicDelegate?.onReceivedError(message: withError.localizedDescription)
            print("WebView content load failed / OnPageError:[\(withError.localizedDescription)]")
        }
        
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            if(webView.isHidden) {
                return
            }
            parent?.garlicDelegate?.onReceivedError(message: withError.localizedDescription)
            print("WebView content load failed / OnPageError:[\(withError.localizedDescription)]")
        }
        
        public func webView(_ uiWebView: UIWebView, didFailLoadWithError: Error) {
            if(uiWebView.isHidden) {
                return
            }
            parent?.garlicDelegate?.onReceivedError(message: didFailLoadWithError.localizedDescription)
            print("WebView content load failed / OnPageError:[\(didFailLoadWithError.localizedDescription)]")
        }
    }
}
