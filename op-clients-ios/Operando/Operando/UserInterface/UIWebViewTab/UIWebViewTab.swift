//
//  UIWebViewTab.swift
//  Operando
//
//  Created by Costin Andronache on 3/17/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit

extension URL {
    static func tryBuildWithHttp(with input: String) -> URL? {
        if let url = URL(string: input), input.contains("http") {
            return url
        }
        
        if let url = URL(string: "http://\(input)") {
            return url
        }
        
        if let url = URL(string: "http://www.\(input)") {
            return url
        }
        
        return nil
        
    }
}

struct UIWebViewTabNavigationList {
    let urlList: [URL]
    let currentURLIndex: Int
    init?(urlList: [URL], currentURLIndex: Int) {
        guard currentURLIndex < urlList.count && currentURLIndex >= 0 else {
            return nil
        }
        self.urlList = urlList
        self.currentURLIndex = currentURLIndex
    }
}



struct UIWebViewTabCallbacks {
    let whenUserChoosesToViewTabs: VoidBlock?
    let urlForUserInput: (_ userInput: String) -> URL
}

class UIWebViewTab: RSNibDesignableView, WKNavigationDelegate, WKUIDelegate {
    
    static let processPool: WKProcessPool = WKProcessPool()
    @IBOutlet weak var addressBarView: UIView!
    
    @IBOutlet weak var webToolbarView: UIWebToolbarView!
    @IBOutlet weak var addressTF: UITextField!
    private var webView: WKWebView?
    private var callbacks: UIWebViewTabCallbacks?
    
    private var urlHistory: [URL] = []
    private var currentURLIndex: Int = 0;
    private var whenWebViewLoadingFinished: VoidBlock?
    
    override func commonInit() {
        super.commonInit()
        let webView = self.createWebView()
        self.webView = webView
        self.constrain(webView: webView)
        self.webToolbarView.setupWith(callbacks: self.callbacksForToolbar())
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let loading = change?[.newKey] as? Bool, loading == true {
            self.whenWebViewLoadingFinished?()
        }
    }
    
    func initializeWith(navigationList: UIWebViewTabNavigationList, callbacks: UIWebViewTabCallbacks) {
        self.callbacks = callbacks
        self.urlHistory = navigationList.urlList
        self.navigateTo(url: navigationList.urlList[navigationList.currentURLIndex])
    }
    
    
    @IBAction func didPressGoButton(_ sender: Any) {
        guard let text = self.addressTF.text else {
            return
        }
        
        self.goWith(userInput: text)
        
    }
    
    
    
    private func goWith(userInput: String) {
        
        let navigateBlock: (_ url: URL) -> Void = { url in
            if self.urlHistory.count == 0 {
                self.urlHistory.append(url)
                self.currentURLIndex = 0;
            }
            
            self.urlHistory[self.currentURLIndex] = url;
            self.urlHistory.removeLast(self.urlHistory.count - self.currentURLIndex)
            self.navigateTo(url: url)
        }
        
        if let url = URL.tryBuildWithHttp(with: userInput) {
            navigateBlock(url)
            return
        }
        
        if let url = self.callbacks?.urlForUserInput(userInput) {
            navigateBlock(url)
        }
    }
    
    
    private func navigateTo(url: URL) {
        let request = URLRequest(url: url)
        self.urlHistory.append(url)
        self.webView?.load(request)
    }
    
    private func createWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = UIWebViewTab.processPool
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = false
            configuration.allowsPictureInPictureMediaPlayback = false;
            configuration.requiresUserActionForMediaPlayback = true;
        } else {
            // Fallback on earlier versions
        };
        configuration.allowsInlineMediaPlayback = false;
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.navigationDelegate = self
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil);
        
        return webView
    }
    
    private func constrain(webView: WKWebView) {
        guard let contentView = self.contentView else {
            return
        }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let buildConstraintForAttribute: (_ attr: NSLayoutAttribute) -> NSLayoutConstraint = { attr in
            return NSLayoutConstraint(item: webView, attribute: attr, relatedBy: .equal, toItem: contentView, attribute: attr, multiplier: 1.0, constant: 0);
        }
        
        let constraints: [NSLayoutConstraint] = [buildConstraintForAttribute(.right), buildConstraintForAttribute(.left),
                                                NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.addressBarView, attribute: .bottom, multiplier: 1.0, constant: 0),
                                                
                                                 NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.webToolbarView, attribute: .top, multiplier: 1.0, constant: 0)]
        
        self.contentView?.addSubview(webView)
        self.contentView?.addConstraints(constraints)
        self.contentView?.setNeedsLayout()
        self.contentView?.layoutIfNeeded()
    }
    
    
    private func goBack() {
        guard currentURLIndex - 1 >= 0 else {
            return
        }
        self.currentURLIndex -= 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex])
    }
    
    private func goForward () {
        guard self.currentURLIndex + 1 < self.urlHistory.count else {
            return
        }
        self.currentURLIndex += 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex])
    }
    
    private func callbacksForToolbar() -> UIWebToolbarViewCallbacks {
        weak var weakSelf = self
        
        return UIWebToolbarViewCallbacks(onBackPress: {
            weakSelf?.goBack()
        }, onForwardPress: {
            weakSelf?.goForward()
        }, onTabsPress: self.callbacks?.whenUserChoosesToViewTabs);
        
    }

    
    //MARK: 
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        guard let url = navigationAction.request.url else {
            return
        }
        weak var weakSelf = self
        
        if navigationAction.navigationType == .linkActivated {
            self.whenWebViewLoadingFinished = {
                weakSelf?.urlHistory.append(url)
                weakSelf?.currentURLIndex += 1
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "loading")
    }
}
