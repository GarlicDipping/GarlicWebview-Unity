//
//  ViewController.swift
//  GarlicWebviewApp
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import UIKit
import GarlicWebview

class TestProtocol : GarlicWebviewProtocol {
    func onReceivedError(message: String) {
        print("onReceivedError: " + message)
    }
    
    func onPageStarted(url: String) {
        print("onPageStarted: " +  url)
    }
    
    func onPageFinished(url: String) {
        print("onPageFinished: " + url)
    }
    
    func onShow() {
        print("onShow")
    }
    
    func onClose() {
        print("onClose")
    }
}

class ViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        GarlicWebviewController.GetInstance().Initialize(parentUIView: self.view!, garlicDelegate: TestProtocol())
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        let marginPx = GarlicUtils.PointToPx(pt: 30)
        GarlicWebviewController.GetInstance().SetFixedRatio(width: 16, height: 9)
        GarlicWebviewController.GetInstance().SetMargins(left: marginPx, right: marginPx, top: marginPx, bottom: marginPx)
        GarlicWebviewController.GetInstance().Show(url: "https://www.teamtapas.com")
    }
}

