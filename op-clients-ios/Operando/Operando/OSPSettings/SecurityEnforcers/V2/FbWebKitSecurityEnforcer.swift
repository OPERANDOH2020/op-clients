//
//  FbWebKitSecurityEnforcer.swift
//  Operando
//
//  Created by Costin Andronache on 8/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

extension NSHTTPCookieStorage
{
    func cookieHeadersFromURL(url: String) -> [String: String]
    {
        guard let urlURL = NSURL(string: url) else {return [:]}
        let cookies = self.cookiesForURL(urlURL)
        return NSHTTPCookie.requestHeaderFieldsWithCookies(cookies ?? []);
    }
    

    
    
}

typealias CallToLoginWithCompletion = (completion: VoidBlock?) -> Void

extension UIWebView
{
    func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString);}
        self.loadRequest(NSURLRequest(URL: url));
        return nil;
    }
    
    func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((result: AnyObject?, error: NSError?) -> Void)?)
    {
        guard let filePath = NSBundle.mainBundle().pathForResource(scriptName, ofType: "js") else {completion?(result: nil, error: nil);return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            self.stringByEvaluatingJavaScriptFromString(jsString as String);
        }
    }
    
    func loadJQueryIfNeededWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed("testJQuery") { (result, error) in
            if let resultString = result as? String
            {
                if resultString == "true"
                {
                    completion?();
                    return;
                }
                
                self.loadAndExecuteScriptNamed("jquery214min", withCompletion: { (result, error) in
                    if error == nil
                    {
                        completion?()
                    }
                })
            }
        }
    }
}

class FbWebKitSecurityEnforcer: NSObject, WKNavigationDelegate, WKUIDelegate
{
    private let webView: UIWebView
    private var whenWebViewFinishesNavigation: VoidBlock?
    
    init(webView: UIWebView)
    {
        self.webView = webView
        super.init()
//        self.webView.UIDelegate = self
//        self.webView.navigationDelegate = self
    }
    
    
    
    
    func enforceWithCallToLogin(callToLoginWithCompletion: CallToLoginWithCompletion?, completion: ((error: NSError?) -> Void)?)
    {
        if let error = self.webView.loadWebViewToURL("https://www.facebook.com")
        {
            completion?(error: error);
            return
        }
        weak var weakSelf = self
        
        self.whenWebViewFinishesNavigation = {
            callToLoginWithCompletion?{
                weakSelf?.webView.loadJQueryIfNeededWithCompletion
                    {
                        weakSelf?.webView.loadAndExecuteScriptNamed("facebook_iOS", withCompletion: { (result, error) in
                            if let error = error
                            {
                                completion?(error: error);
                                return
                            }
                            
                            
                        })
                }
            }
            
        }
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.whenWebViewFinishesNavigation?();
    }
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
        if let jsonData = message.dataUsingEncoding(NSUTF8StringEncoding),
        jsonObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [String: AnyObject],
        info = jsonObject
        {
            var windowValue: String = "finished";
            
            self.makePOSTRequestWithInfo(info, completion: { (error) in
                if let _ = error
                {
                    windowValue  = "terminated";
                }
                
                
                self.webView.evaluateJavaScript("window[\"lastRequestStatus\"]=\(windowValue)", completionHandler: { result, error in
                    completionHandler();
                })
                
            })
        }
    }
    
    
    
    func makePOSTRequestWithInfo(info: [String: AnyObject], completion: ((error: NSError?) -> Void)?)
    {
        guard let request = createRequestWithInfo(info) else
        {
            completion?(error: NSError.errorPOSTinfoDict);
            return;
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error  in
            if let error = error
            {
                completion?(error: error);
                return;
            }
            
            if let data = data, stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            {
                print(stringData);
            }
            
            if let httpResponse = response as? NSHTTPURLResponse
            {
                if httpResponse.statusCode != 200
                {
                    completion?(error: NSError.errorPOSTFailed);
                    return;
                }
            }
            
            completion?(error: nil);
        }
        
        task.resume()
        
    }
    
    
    func createRequestWithInfo(info: [String: AnyObject]) -> NSURLRequest?
    {
        guard let urlString = info["url"] as? String,
                  cookiesURLSource = info["cookiesURLSource"] as? String,
            url = NSURL(string: urlString),
            headers = info["headers"] as? [String: String],
            dataInJSON = info["dataInJSON"] as? NSDictionary
            else
        {
            return nil
        }
        
        
        var requestHeaders = headers
        
        //trying to force webview to flush all cookies into sharedCookieStorage
        self.webView.configuration.processPool = WKProcessPool()
        //
        
        let cookieHeaders = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieHeadersFromURL(cookiesURLSource)
        cookieHeaders.forEach { (key, value) in
            requestHeaders[key] = value
        }
        
        let requestPOSTData = dataInJSON.postBodyString
        
        let request = NSMutableURLRequest(URL: url)
        request.allHTTPHeaderFields = requestHeaders
        request.HTTPBody = requestPOSTData.dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
}
