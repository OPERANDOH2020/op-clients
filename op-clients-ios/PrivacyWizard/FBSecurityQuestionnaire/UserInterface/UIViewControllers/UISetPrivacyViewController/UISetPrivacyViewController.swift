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
let MozillaUserAgentId = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"

class UISetPrivacyViewController: UIViewController {

    // MARK: - Properties
    private var whenUserPressedLoggedIn: VoidBlock?
    private var fbSecurityEnforcer: FbWebKitSecurityEnforcer?
    
    private var webView: WKWebView = WKWebView(frame: .zero)
    private var tutorialView: UIView?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webViewHostView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var loggedInButton: UIButton!
    
    // MARK: - @IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoggedInButton(_ sender: Any) {
        self.whenUserPressedLoggedIn?()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        loggedInButton.layer.borderWidth = 1
        loggedInButton.layer.borderColor = UIColor.appYellow.cgColor
        loggedInButton.layer.cornerRadius = 5.0
        loggedInButton.backgroundColor = .appDarkBlue
        navigationView.backgroundColor = .appDarkBlue
        
        UIView.constrainView(view: webView, inHostView: self.webViewHostView)
        if #available(iOS 9.0, *) {
            self.webView.customUserAgent = MozillaUserAgentId
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        self.fbSecurityEnforcer = FbWebKitSecurityEnforcer(webView: self.webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alterUserAgentInDefaults()
        
        //self.addTutorialView()
        self.fbSecurityEnforcer?.enforceWithCallToLogin(callToLoginWithCompletion: { callbackWhenLogInIsDone in
            //RSCommonUtilities.showOKAlertWithMessage(message: "Please log in and then press the button named 'Logged In' ");
            self.whenUserPressedLoggedIn = {
                callbackWhenLogInIsDone?()
                self.whenUserPressedLoggedIn = nil
            }
            
        }, whenDisplayingMessage: {RSCommonUtilities.showOKAlertWithMessage(message: $0)}, completion: { error in
            if let error = error {
                RSCommonUtilities.showOKAlertWithMessage(message: error.localizedDescription)
                return
            }
            
            RSCommonUtilities.showOKAlertWithMessage(message: "Your facebook settings have ben secured")
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func alterUserAgentInDefaults()
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : MozillaUserAgentId as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultsUserAgent)
        UserDefaults.standard.synchronize()
    }
    
    private func addTutorialView() {
        tutorialView = UIView(frame: self.view.frame)
        let rect = loggedInButton.frame
        UIApplication.shared.isStatusBarHidden = true
        tutorialView?.addSubview(withBackgroundColor: .appDarkBlue, alpha: 0.9, cropRectFrom: CGPoint(x: rect.minX, y: rect.minY) , width: rect.width, height: rect.height)
        view.addSubview(tutorialView!)
    }
}
