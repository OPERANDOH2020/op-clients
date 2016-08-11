//
//  WebViewSettingsApplier.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

extension NSError
{
    static func malformedURLError(url: String) -> NSError
    {
        return NSError(domain: "com.operando.operando", code: -8, userInfo: [NSLocalizedDescriptionKey : "Received a malformed url: \(url) \n Please send a screenshot to support for this issue"])
    }
}

let alertLoginMessage = "Please login with your own credentials on this site, and press the 'Done' button when you're finished"

class WebViewSettingsApplier: NSObject, OSPSettingsApplier, UIWebViewDelegate
{
    weak var webView: UIWebView?
    weak var button: UIButton?
    
    var whenLoginButtonIsPressed: VoidBlock?
    var whenWebViewFinishesLoad: VoidBlock?
    var whenWebViewLoadsWithError: ErrorCallback?
    
    
    init(loginFinishedButton: UIButton?, webView: UIWebView?)
    {
        self.webView = webView
        self.button = loginFinishedButton
        super.init()
        webView?.delegate = self
        
        button?.addTarget(self, action: #selector(WebViewSettingsApplier.loginFinishedButtonDidPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    private func clearAllCallbacks()
    {
        self.whenWebViewFinishesLoad = nil
        self.whenWebViewLoadsWithError = nil
        self.whenLoginButtonIsPressed = nil
    }
    
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?)
    {
        if let error = self.loadWebViewToURL(site)
        {
            completion?(error: error)
            return
        }
        
        self.clearAllCallbacks()
        
        weak var weakSelf = self
        self.whenWebViewLoadsWithError = completion
        self.whenWebViewFinishesLoad = {
            
            weakSelf?.whenWebViewFinishesLoad = nil
            RSCommonUtilities.showOKAlertWithMessage(alertLoginMessage)
            weakSelf?.whenLoginButtonIsPressed =
            {
                weakSelf?.clearAllCallbacks()
                completion?(error: nil)
            }
            
        }
    }
    
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        self.clearAllCallbacks()
        weak var weakSelf = self
        
        if let error = self.loadWebViewToURL(address)
        {
            completion?(readSettings: nil, error: error)
            return
        }
        
        self.whenWebViewFinishesLoad = {
            weakSelf?.whenWebViewFinishesLoad = nil
            weakSelf?.readSettingsBasedOnJsonString(settingsAsJsonString, completion: completion)
        }
        
        self.whenWebViewLoadsWithError = { error in
            weakSelf?.whenWebViewLoadsWithError = nil
            completion?(readSettings: nil, error: error)
        }
    }
    
    
    private func readSettingsBasedOnJsonString(settingsAsJsonString: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        
        loadReadingFunctionInWebView()
        let escapedString = settingsAsJsonString.stringByReplacingOccurrencesOfString("\"", withString: "\\\"").stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
        
        let results = self.webView?.stringByEvaluatingJavaScriptFromString("window.readSettings(\"\(escapedString)\")")
        
        
        completion?(readSettings: nil, error: nil)
    }
    
    private func loadReadingFunctionInWebView()
    {
        guard let filePath = NSBundle.mainBundle().pathForResource("readSNSettings", ofType: "js") else {return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            self.webView?.stringByEvaluatingJavaScriptFromString(jsString as String)
        }
    }
    
    private func readSNSettingsStringScriptCalledWith(param: String) -> String
    {
        let script = "(function (settingJsonString)" +
        "{" +
            "var jquery_selector = JSON.parse(settingJsonString);" +
            "switch (jquery_selector.valueType){" +
            "case 'attrValue': setting = jQuery(jquery_selector.element).attr(jquery_selector.attrValue); break;" +
            "case 'checkbox': setting = jQuery(jquery_selector.element).attr(\"checked\")?true:false; break;" +
            "case 'inner': setting = jQuery(jquery_selector.element).text(); break;" +
            "case 'classname': setting = jQuery(jquery_selector.element).hasClass(jquery_selector.attrValue); break;" +
            "case 'radio' :setting = jQuery(jquery_selector.element + \":checked\").attr(\"value\"); break;" +
            "case 'selected' : setting = jQuery(jquery_selector.element).attr(\"value\"); break;" +
            "case 'length' : setting = jQuery(jquery_selector.element).length?jQuery(jquery_selector.element).length:0; break;" +
            "default: setting = null;" +
            "}" +

            "return JSON.stringify({settingKey:setting.settingKey, setting:setting});" +
        "})" + "(\"" + param + "\")"
        
        return script.stringByReplacingOccurrencesOfString("\\'", withString: "")
    }
    
    
    //MARK: UIWebViewDelegate and button action
    func webViewDidFinishLoad(webView: UIWebView) {
        self.whenWebViewFinishesLoad?()
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        return;
        self.whenWebViewLoadsWithError?(error: error)
    }
    
    
    func loginFinishedButtonDidPress(sender: UIButton)
    {
        self.whenLoginButtonIsPressed?()
    }
    
    
    private func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString)}
        let request = NSURLRequest(URL: url)
        
        self.webView?.loadRequest(request)
        
        return nil
    }
}