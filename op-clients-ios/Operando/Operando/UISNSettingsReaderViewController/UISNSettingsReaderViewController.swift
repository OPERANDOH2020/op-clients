//
//  UISNSettingsReaderViewController.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISNSettingsReaderViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    let ospSettingsManager = OSPSettingsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsUserAgent)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let settingsApplier = WebViewSettingsApplier(loginFinishedButton: self.loginButton, webView: self.webView)
        let settingsProvider = LocalJSSettingsProvider()
        
        self.ospSettingsManager.readSettingsWithProvider(settingsProvider, andApplier: settingsApplier) { (results, error) in
            print(results)
            print(error)
        }
        
    }

}
