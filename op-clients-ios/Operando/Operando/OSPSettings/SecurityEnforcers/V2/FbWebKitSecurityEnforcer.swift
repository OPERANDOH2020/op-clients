//
//  FbWebKitSecurityEnforcer.swift
//  Operando
//
//  Created by Costin Andronache on 8/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit


enum POSTRequestStatus: String
{
    case Finished = "finished"
    case TerminatedWithError = "terminated"
}



typealias CallToLoginWithCompletion = (_ callbackWhenLoginIsDone: VoidBlock?) -> Void

let kMessageTypeKey = "messageType";

let kLogMessageTypeContentKey = "logContent";
let kLogMessageType = "log";

let kStatusMessageMessageType = "statusMessageType";
let kStatusMessageContentKey = "statusMessageContent";

class FbWebKitSecurityEnforcer: NSObject, WKNavigationDelegate, WKUIDelegate
{
    private let webView: WKWebView
    private var whenWebViewFinishesNavigation: VoidBlock?
    private var whenDisplayingMessage: ((_ message: String) -> Void)?
    
    
    init(webView: WKWebView)
    {
        self.webView = webView
        super.init()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
    }
    
    
    func enforceWithCallToLogin(callToLoginWithCompletion: CallToLoginWithCompletion?, whenDisplayingMessage: ((_ message: String) -> Void)? ,completion: ((_ error: NSError?) -> Void)?)
    {
        if let error = self.webView.loadWebViewToURL(urlString: "https://www.facebook.com")
        {
            completion?(error);
            return
        }
        
        self.whenDisplayingMessage = whenDisplayingMessage;
        
        weak var weakSelf = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { 
            callToLoginWithCompletion?{
                self.loginIsDoneInitiateNextStep()
            }
            
            weakSelf?.whenWebViewFinishesNavigation = nil;

        }
        
        
    }
    
    
    private func loginIsDoneInitiateNextStep()
    {
        self.webView.loadAndExecuteScriptNamed(scriptName: "facebook_iOS") { (result, error) in
            print(error);
            print(result);
        }
    }
    
    

    
    private func loadJSFileInWebView()
    {
        let jsFile = self.getJSFile()
        let userScript = WKUserScript(source: jsFile, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)
    }
    
    private func getJSFile() -> String
    {
        guard let path = Bundle.main.path(forResource: "facebook_iOS", ofType: "js") else {return ""}
        let js = try? String(contentsOfFile: path)
        return js ?? ""
    }
    
    //MARK: WKWebView delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.whenWebViewFinishesNavigation?()
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler();
        
        if let data = message.data(using: String.Encoding.utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let messageDict = jsonObject as? [String: String]
        {
            self.handleMessage(message: messageDict)
        }
        
    }
    

    
    //MARK: internal utils
    
    private func handleMessage(message: [String: String])
    {
        guard let messageType = message[kMessageTypeKey] else {return}
        
        if messageType == kLogMessageType
        {
            print(message[kLogMessageTypeContentKey])
            return;
        }
        
        //
        if let statusMessage = message[kStatusMessageContentKey]
        {
            self.whenDisplayingMessage?(statusMessage)
        }
    }
}
