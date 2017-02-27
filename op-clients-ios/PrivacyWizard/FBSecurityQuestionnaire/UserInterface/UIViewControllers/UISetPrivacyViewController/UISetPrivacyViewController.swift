//
//  UISetPrivacyViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit
import WebKit

let UISetPrivacyVCStoryboardId = "UISetPrivacyVCStoryboardId"

class UISetPrivacyViewController: UIViewController {

    // MARK: - Properties
    private var whenUserPressedLoggedIn: VoidBlock?
    private var fbSecurityEnforcer: FbWebKitSecurityEnforcer?
    
    private var webView: WKWebView = WKWebView(frame: .zero)
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webViewHostView: UIView!
    
    // MARK: - @IBActions
    func didTapBackButtonItem() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func didPressLoggedInButton() {
        self.whenUserPressedLoggedIn?()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.addCustomBackButton(target: self, selector: #selector(UISetPrivacyViewController.didTapBackButtonItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logged In", style: .plain, target: self, action: #selector(UISetPrivacyViewController.didPressLoggedInButton))
        UIView.constrainView(view: webView, inHostView: self.webViewHostView)
        if #available(iOS 9.0, *) {
            self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
        }
        
        self.fbSecurityEnforcer = FbWebKitSecurityEnforcer(webView: self.webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alterUserAgentInDefaults()
        
        self.fbSecurityEnforcer?.enforceWithCallToLogin(callToLoginWithCompletion: { callbackWhenLogInIsDone in
            RSCommonUtilities.showOKAlertWithMessage(message: "Please log in and then press the button named 'Logged In' ");
            
            self.whenUserPressedLoggedIn = {
                callbackWhenLogInIsDone?()
                //self.whenUserPressedLoggedIn = nil
            }
            
        }, whenDisplayingMessage: {RSCommonUtilities.showOKAlertWithMessage(message: $0)}, completion: { error in
            if let error = error {
                RSCommonUtilities.showOKAlertWithMessage(message: error.localizedDescription)
                return
            }
            
            RSCommonUtilities.showOKAlertWithMessage(message: "Your facebook settings have ben secured")
        })
    }
    
    private func alterUserAgentInDefaults()
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12" as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultsUserAgent)
        UserDefaults.standard.synchronize()
    }
}
