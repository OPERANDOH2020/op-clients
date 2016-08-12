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
    
    @IBOutlet weak var beginNewReadingButton: UIButton!
    @IBOutlet weak var webViewHost: UIView!
    let ospSettingsManager = OSPSettingsManager()
    
    @IBOutlet weak var snSettingsView: UISNSettingsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.alpha = 0;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startANewReading()
    }
    
    
    @IBAction func didPressBeginNewReading(sender: AnyObject)
    {
        self.startANewReading()
    }
    
    func startANewReading()
    {
        self.beginNewReadingButton.alpha = 0.0;
        self.loginButton.alpha = 1.0;
        self.webViewHost.alpha = 1.0
        self.snSettingsView.alpha = 0.0;
        
        self.beginNewReadingWithCompletion { (results, error) in
            
            self.loginButton.alpha = 0.0;
            self.beginNewReadingButton.alpha = 1.0;
            self.webViewHost.alpha = 0.0
            
            if let results = results
            {
                self.snSettingsView.alpha = 1.0;
                self.snSettingsView.reloadWithItems(results)
            }
            
        }
        
    }
    
    
    
    func beginNewReadingWithCompletion(completion: ((results: [SettingsReadResult]?, error: NSError?) -> Void)?)
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsUserAgent)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let settingsApplier = WebKitSettingsApplier(loginIsDoneButton: self.loginButton)
        UIView.constrainView(settingsApplier.webView, inHostView: self.webViewHost)
        self.view.bringSubviewToFront(self.loginButton)
        
        
        let settingsProvider = LocalJSSettingsProvider()
        
        self.ospSettingsManager.readSettingsWithProvider(settingsProvider, andApplier: settingsApplier) { (results, error) in
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("UserAgent");
            NSUserDefaults.standardUserDefaults().synchronize();
            
            completion?(results: results, error: error);
        }
    }
    
}
