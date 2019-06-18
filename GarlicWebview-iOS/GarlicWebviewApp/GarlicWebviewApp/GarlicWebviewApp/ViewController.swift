//
//  ViewController.swift
//  GarlicWebviewApp
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import UIKit
import GarlicWebview

class ViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        GarlicWebviewController.shared.Initialize(parentUIView: self.view!)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        GarlicWebviewController.shared.Show(url: "https://www.google.com")
    }
}

