//
//  UIPrivateBrowsingViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

class UIPrivateBrowsingViewController: UIViewController, WKNavigationDelegate
{
    
    @IBOutlet weak var browsingNavigationBar: UIBrowsingNavigationBar!
    @IBOutlet weak var webViewHostView: UIView!
    var wkWebView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView = self.createWebViewInHostView(hostView: self.webViewHostView);
        self.wkWebView?.load(NSURLRequest(url: NSURL(string: "https://www.google.ro")! as URL) as URLRequest);
        self.browsingNavigationBar.setupWithCallbacks(callbacks: self.callBacksForBrowsingBar(browsingBar: self.browsingNavigationBar));
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        let detector = HTMLLoginInputDetector()
        detector.detectLoginInputsInWebView(webView: webView) { (result) in
            if let detectionResult = result
            {
                print("login input id \(detectionResult.loginInputId), password input id = \(detectionResult.passwordInputId)")
            }
            else
            {
                print("No input items could be detected");
            }
        }
    }
    
    
    private func callBacksForBrowsingBar(browsingBar: UIBrowsingNavigationBar) -> UIBrowsingNavigationBarCallbacks?
    {
        weak var weakSelf = self;
        return UIBrowsingNavigationBarCallbacks(whenUserPressedBack: { 
            weakSelf?.wkWebView?.goBack()
            },
            whenUserPressedSearchWithString: { (searchString) in
                weakSelf?.goToAddressOrSearch(string: searchString)
        })
    }
    
    private func goToAddressOrSearch(string: String)
    {
        if let url = NSURL(string: "https://" + string) ?? NSURL(string: string)
        {
            self.wkWebView?.load(NSURLRequest(url: url as URL) as URLRequest)
        }
        else
        {
            print("Must apply search for " + string)
        }
    }
    
    private func createWebViewInHostView(hostView: UIView) -> WKWebView
    {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        UIView.constrainView(view: webView, inHostView: hostView)
        return webView
    }
}
