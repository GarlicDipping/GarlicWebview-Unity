//
//  GarlicWebviewUnityWrapper.swift
//  GarlicWebviewiOS-Bridge
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import Foundation
import GarlicWebview

@objc public class GarlicWebviewUnityWrapper : NSObject, GarlicWebviewProtocol {
    @objc public func Initialize(parentUIView:UIViewController) {
        GarlicWebviewController.shared.Initialize(parentUIView: parentUIView.view!, garlicDelegate: self)
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
    
    func onReceivedError(message: String) {
        UnitySendMessage("GarlicWebview", "onReceivedError", message)
    }
    
    func onPageStarted(url: String) {
        UnitySendMessage("GarlicWebview", "onPageStarted", url)
    }
    
    func onPageFinished(url: String) {
        UnitySendMessage("GarlicWebview", "onPageFinished", url)
    }
    
    func onShow() {
        UnitySendMessage("GarlicWebview", "onShow", "")
    }
    
    func onClose() {
        UnitySendMessage("GarlicWebview", "onClose", "")
    }
    
}
