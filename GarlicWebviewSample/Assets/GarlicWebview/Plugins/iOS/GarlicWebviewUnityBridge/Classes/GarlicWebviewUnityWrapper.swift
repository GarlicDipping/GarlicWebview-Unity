//
//  GarlicWebviewUnityWrapper.swift
//  GarlicWebviewiOS-Bridge
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import Foundation
import GarlicWebview
import UIKit

@objc public class GarlicWebviewUnityWrapper : NSObject, GarlicWebviewProtocol {
    @objc public func Initialize(parentUIView:UIViewController) {
        GarlicWebviewController.shared.Initialize(parentUIView: parentUIView.view!, garlicDelegate: self)
    }
    
    @objc public func SetMargins(left: Int, right: Int, top: Int, bottom: Int) {
        GarlicWebviewController.shared.SetMargins(left: CGFloat(left), right: CGFloat(right), top: CGFloat(top), bottom: CGFloat(bottom))
    }
    
    @objc public func SetFixedRatio(width: Int, height: Int) {
        GarlicWebviewController.shared.SetFixedRatio(width: width, height: height)
    }
    
    @objc public func UnsetFixedRatio() {
        GarlicWebviewController.shared.UnsetFixedRatio()
    }
    
    @objc public func Show(url: String) {
        GarlicWebviewController.shared.Show(url: url)
    }
    
    @objc public func Close() {
        GarlicWebviewController.shared.Close()
    }
    
    @objc public func Dispose() {
        GarlicWebviewController.shared.Dispose()
    }
    
    public func onReceivedError(message: String) {
        UnitySendMessage("GarlicWebview", "__fromnative_onReceivedError", message)
    }
    
    public func onPageStarted(url: String) {
        UnitySendMessage("GarlicWebview", "__fromnative_onPageStarted", url)
    }
    
    public func onPageFinished(url: String) {
        UnitySendMessage("GarlicWebview", "__fromnative_onPageFinished", url)
    }
    
    public func onShow() {
        UnitySendMessage("GarlicWebview", "__fromnative_onShow", "")
    }
    
    public func onClose() {
        UnitySendMessage("GarlicWebview", "__fromnative_onClose", "")
    }
    
}
