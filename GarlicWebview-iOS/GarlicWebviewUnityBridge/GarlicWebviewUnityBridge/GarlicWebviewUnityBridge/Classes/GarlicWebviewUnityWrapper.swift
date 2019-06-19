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

extern void UnitySendMessage(const char *, const char *, const char *);

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
    
    public func onReceivedError(message: String) {
        UnitySendMessage("GarlicWebview", "onReceivedError", message)
    }
    
    public func onPageStarted(url: String) {
        UnitySendMessage("GarlicWebview", "onPageStarted", url)
    }
    
    public func onPageFinished(url: String) {
        UnitySendMessage("GarlicWebview", "onPageFinished", url)
    }
    
    public func onShow() {
        UnitySendMessage("GarlicWebview", "onShow", "")
    }
    
    public func onClose() {
        UnitySendMessage("GarlicWebview", "onClose", "")
    }
    
}
