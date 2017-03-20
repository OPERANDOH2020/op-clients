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



struct UIWebViewTabNavigationModel {
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

struct UIWebViewTabModel {
    let navigationModel: UIWebViewTabNavigationModel?
    let processPool: WKProcessPool
}


struct UIWebViewTabCallbacks {
    let whenUserChoosesToViewTabs: VoidBlock?
    let urlForUserInput: (_ userInput: String) -> URL
}

struct WebTabDescription {
    let name: String
    let screenshot: UIImage?
    let favIconURL: String?
}

fileprivate let kIconsMessageHandler = "iconsMessageHandler"

class UIWebViewTab: RSNibDesignableView, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var addressBarView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webToolbarView: UIWebToolbarView!
    @IBOutlet weak var addressTF: UITextField!
    
    private var webView: WKWebView?
    
    private var callbacks: UIWebViewTabCallbacks?
    private var urlHistory: [URL] = []
    private var currentURLIndex: Int = 0;
    var currentNavigationModel: UIWebViewTabNavigationModel? {
        return UIWebViewTabNavigationModel(urlList: self.urlHistory, currentURLIndex: self.currentURLIndex)
    }
    
    //MARK: -
    
    override func commonInit() {
        super.commonInit()
        self.activityIndicator.isHidden = true

    }
    
    func setupWith(model: UIWebViewTabModel, callbacks: UIWebViewTabCallbacks?) {
        self.callbacks = callbacks
        
        let configuration = self.createConfigurationWith(processPool: model.processPool)
        let webView = self.createWebViewWith(configuration: configuration)
        self.webView = webView
        self.constrain(webView: webView)
        self.contentView?.bringSubview(toFront: self.activityIndicator)
        self.webToolbarView.setupWith(callbacks: self.callbacksForToolbar())
        
        if let navigationModel = model.navigationModel {
            self.changeNavigationModel(to: navigationModel)
        }
    }
    
    func changeNavigationModel(to model: UIWebViewTabNavigationModel) {
        self.urlHistory = model.urlList
        self.currentURLIndex = model.currentURLIndex;
        self.navigateTo(url: model.urlList[model.currentURLIndex])
        self.addressTF.text = model.urlList[model.currentURLIndex].absoluteString
    }
    
    func createDescriptionWithCompletionHandler(_ handler: ((_ description: WebTabDescription) -> Void)?){
        guard let webView = self.webView else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0);
        webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.getFavIconURL { urlString  in
            self.getPageTitle { pageTitle in
                handler?(WebTabDescription(name: pageTitle ?? "", screenshot: snapshotImage, favIconURL: urlString))
            }
        }
    }
    
    
    func getPageTitle(in callback: ((_ title: String?) -> Void)?){
        self.webView?.evaluateJavaScript(self.pageTitleScript(), completionHandler: { result, error  in
            callback?(result as? String)
        })
    }
    
    func getFavIconURL(in callback: ((_ url: String?) -> Void)?) {
        self.webView?.evaluateJavaScript(self.iconURLListScript(), completionHandler: { result, error  in
            if let resultArray = result as? [String],
                let first = resultArray.first {
                callback?(first)
            }
        })
    }
    
    @IBAction func didPressGoButton(_ sender: Any) {
        guard let text = self.addressTF.text else {
            return
        }
        self.goWith(userInput: text)
    }
    
    
    
    private func goWith(userInput: String) {
        
        let navigateBlock: (_ url: URL) -> Void = { url in
            self.addNewURLInHistory(url)
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
        self.webView?.load(request)
    }
    
    private func createWebViewWith(configuration: WKWebViewConfiguration) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        
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
    
    private func addNewURLInHistory(_ url: URL) {
        if self.urlHistory.count == 0 {
            self.currentURLIndex = 0;
        } else {
            self.currentURLIndex += 1;
        }
        
        self.urlHistory.append(url)
        
        
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

    private func createConfigurationWith(processPool: WKProcessPool) -> WKWebViewConfiguration {
        
        let configuration = WKWebViewConfiguration()
        configuration.processPool = processPool
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = false
            configuration.allowsPictureInPictureMediaPlayback = false;
            configuration.requiresUserActionForMediaPlayback = true;
        } else {
            // Fallback on earlier versions
        };
        configuration.allowsInlineMediaPlayback = false;
        return configuration
        
    }
    
    //MARK: -
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        guard let url = navigationAction.request.url else {
            return
        }
        
        if navigationAction.navigationType != .other &&
            navigationAction.navigationType != .reload {
            self.addNewURLInHistory(url)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.isHidden = true
        self.addressTF.text = webView.url?.absoluteString
    }
    
    //MARK: -
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
    
    
    
    func iconURLListScript() -> String {
        return "(function(){for(var a=document.getElementsByTagName(\"link\"),b=[],c=0;c<a.length;c++){var d=a[c],e=d.getAttribute(\"rel\");if(e&&e.toLowerCase().indexOf(\"icon\")>-1){var f=d.getAttribute(\"href\");if(f)if(f.toLowerCase().indexOf(\"https:\")==-1&&f.toLowerCase().indexOf(\"http:\")==-1&&0!=f.indexOf(\"//\")){var g=window.location.protocol+\"//\"+window.location.host;if(window.location.port&&(g+=\":\"+window.location.port),0==f.indexOf(\"/\"))g+=f;else{var h=window.location.pathname.split(\"/\");h.pop();var i=h.join(\"/\");g+=i+\"/\"+f}b.push(g)}else if(0==f.indexOf(\"//\")){var j=window.location.protocol+f;b.push(j)}else b.push(f)}}  return b;})()"
    }
    
    func pageTitleScript() -> String {
        return "(function(){return document.title;})()"
    }
}
