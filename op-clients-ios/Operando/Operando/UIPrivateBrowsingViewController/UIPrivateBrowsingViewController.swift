//
//  UIPrivateBrowsingViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

let kSearchEngineURL = "https://www.duckduckgo.com"
let queryURLPart = "\(kSearchEngineURL)/?q="

class UIPrivateBrowsingViewController: UIViewController, WKNavigationDelegate
{
    
    @IBOutlet weak var browsingNavigationBar: UIBrowsingNavigationBar!
    @IBOutlet weak var webViewHostView: UIView!
    var wkWebView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView = self.createWebViewInHostView(hostView: self.webViewHostView);
        self.wkWebView?.load(URLRequest(url: URL(string: kSearchEngineURL)!));
        
        self.browsingNavigationBar.setupWithCallbacks(callbacks: self.callBacksForBrowsingBar(browsingBar: self.browsingNavigationBar));
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
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
        
        let searchURL = queryURLPart + (string.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? "")
        
        self.wkWebView?.load(URLRequest(url: URL(string: searchURL)!))

        
    }
    
    private func createWebViewInHostView(hostView: UIView) -> WKWebView
    {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = false
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = false
        } else {
            // Fallback on earlier versions
        }
        
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        UIView.constrainView(view: webView, inHostView: hostView)
        return webView
    }
}
