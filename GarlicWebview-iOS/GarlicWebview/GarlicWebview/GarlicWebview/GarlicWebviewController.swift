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

public class GarlicWebviewController: NSObject {
    public static let shared = GarlicWebviewController()
    static let DEFAULT_MARGIN = CGFloat(30.0)
    static let CLOSE_BUTTON_SIZE = CGFloat(50.0)
    
    var webViewDelegate: GarlicWebviewDelegate!
    var webView: WKWebView!
    var closeButton: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func Initialize(parentUIView: UIView) {
        if(webView != nil) {
            //print("WebView Already Initialized!")
            return
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GarlicWebviewController.onRotate),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        //webView = WKWebView(frame: parentUIView.frame, configuration: webConfiguration)
        webViewDelegate = GarlicWebviewDelegate()
        webView.uiDelegate = webViewDelegate
        webView.navigationDelegate = webViewDelegate
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isHidden = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        parentUIView.addSubview(webView)
        
        let bundle = Bundle(for: type(of: self))
        let buttonSize = GarlicWebviewController.CLOSE_BUTTON_SIZE
        let buttonImage = UIImage(named: "exit_webview", in: bundle, compatibleWith: nil) as UIImage?
        closeButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        closeButton.frame = CGRect.init(x: webView.frame.maxX - buttonSize / 2,
            y: webView.frame.minY - buttonSize / 2,
            width: buttonSize,
            height: buttonSize)
        //closeButton = UIButton(frame: CGRect(x: webView.frame.maxX, y: webView.frame.minY - buttonSize, width: buttonSize, height: buttonSize))
        closeButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        closeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        closeButton.setImage(buttonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
        closeButton.isHidden = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        parentUIView.addSubview(closeButton)
    }
    
    @objc func onRotate() {
        if webView != nil {
            webView.frame = GetDefaultMarginedFrame(parentUIView: webView.superview!)
            let buttonSize = GarlicWebviewController.CLOSE_BUTTON_SIZE
            closeButton.frame = CGRect.init(x: webView.frame.maxX - buttonSize / 2,
                                            y: webView.frame.minY - buttonSize / 2,
                                            width: buttonSize,
                                            height: buttonSize)
        }
        
        if UIDevice.current.orientation.isLandscape {
            //print("Landscape")
        } else {
            //print("Portrait")
        }
    }
    
    @objc func onClickClose(sender: UIButton!) {
        self.Close()
    }
    
    public func Show(url: String) {
        if(webView == nil) {
            print("WebView NOT initialized!")
            return
        }
        webView.isHidden = false
        closeButton.isHidden = false
        
        let myURL = URL(string:url)
        var myRequest = URLRequest(url: myURL!)
        myRequest.httpShouldHandleCookies = false
        webView.load(myRequest)
    }
    
    public func Close() {
        if(webView == nil) {
            print("Close() / WebView NOT initialized!")
            return
        }
        webView.isHidden = true
        closeButton.isHidden = true
        webView.stopLoading()
        webView.load(URLRequest(url: URL(string:"about:blank")!))
        ClearCache()
    }
    
    public func Dispose() {
        if(webView == nil) {
            print("Dispose() / WebView NOT initialized!")
            return
        }
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.stopLoading()
        webView.removeFromSuperview()
        webView = nil
        closeButton = nil
        webViewDelegate = nil
    }
    
    public func SetMargins(parentUIView: UIView, left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        if (webView == nil) {
            return
        }
        
        var frame = webView.frame
        let screen = self.GetSafeArea(parentUIView: parentUIView)//parentUIView.bounds
        let scale = 1.0 / self.GetScale(parentUIView: parentUIView)
        frame = GetMarginedFrame(originalFrame: frame, safeAreaBound: screen, scale: scale, left: left, top: top, right: right, bottom: bottom)
        webView.frame = frame
    }
    
    private func GetDefaultMarginedFrame(parentUIView: UIView) -> CGRect {
        let frame = parentUIView.frame
        let screen = self.GetSafeArea(parentUIView: parentUIView)//parentUIView.bounds
        let scale = 1.0 / self.GetScale(parentUIView: parentUIView)
        return GetMarginedFrame(originalFrame: frame, safeAreaBound: screen, scale: scale,
                                left: GarlicWebviewController.DEFAULT_MARGIN,
                                top: GarlicWebviewController.DEFAULT_MARGIN,
                                right: GarlicWebviewController.DEFAULT_MARGIN,
                                bottom: GarlicWebviewController.DEFAULT_MARGIN)
    }
    
    private func GetMarginedFrame(originalFrame: CGRect, safeAreaBound: CGRect, scale: CGFloat, left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> CGRect{
        //let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var frame = originalFrame
        frame.size.width = safeAreaBound.size.width - scale * (left + right)
        frame.size.height = (safeAreaBound.size.height) - scale * (top + bottom)
        frame.origin.x = safeAreaBound.origin.x + scale * left
        frame.origin.y = safeAreaBound.origin.y + scale * top
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
    
    private func GetScale(parentUIView: UIView) -> CGFloat {
        //I'm not going to expose SetMargins() method for now, so just going to use iOS point unit for close button.
        return 1.0
        /*if #available(iOS 8.0, *) {
            return UIScreen.main.nativeScale
        }
        return parentUIView.contentScaleFactor */
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
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView content load done / OnPageFinished")
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("WebView content load start / OnPageStarted")
        }
        
        public func webView(_ webView: WKWebView, didFail: WKNavigation!, withError: Error) {
            print("WebView content load failed / OnPageError")
        }
        
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            print("WebView content load failed / OnPageError")
        }
        
        public func webView(_ uiWebView: UIWebView, didFailLoadWithError: Error) {
            print("WebView content load failed / OnPageError")
        }
    }
}
