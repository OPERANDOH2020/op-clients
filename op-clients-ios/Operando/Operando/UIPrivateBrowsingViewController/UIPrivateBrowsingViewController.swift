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

class WebTab {
    var webTabDescription: WebTabDescription?
    var navigationModel: UIWebViewTabNavigationModel?
}

class UIPrivateBrowsingViewController: UIViewController, WKNavigationDelegate
{
    private let sharedProcessPool = WKProcessPool()
    @IBOutlet weak var webViewTab: UIWebViewTab!
    @IBOutlet weak var webTabsView: UIWebTabsView!
    @IBOutlet weak var webTabsViewTopCn: NSLayoutConstraint!
    
    private var webTabs: [WebTab] = []
    private var activeTabIndex: Int = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNewTab()
        self.activeTabIndex = 0;
        
        let model = UIWebViewTabModel(navigationModel: self.webTabs[self.activeTabIndex].navigationModel, processPool: self.sharedProcessPool)
        self.webViewTab.setupWith(model: model, callbacks: self.callbacksForWebView())
        self.setTabsViewTopConstraint(to: UIScreen.main.bounds.size.height)
    
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
    
    private func createDefaultWebTab() -> WebTab {
        let wt = WebTab()
        if let url = URL(string: kSearchEngineURL){
            let nm = UIWebViewTabNavigationModel(urlList: [url], currentURLIndex: 0)
            wt.navigationModel = nm
        }
        return wt
    }
    
    //MARK:
    
    private func addNewTab() {
        let newTab = self.createDefaultWebTab()
        self.webTabs.append(newTab)
    }
    
    private func saveCurrentTabStateWithCompletion(_ completion: VoidBlock?) {
        self.webViewTab.createDescriptionWithCompletionHandler { description in
            self.webTabs[self.activeTabIndex].webTabDescription = description
            self.webTabs[self.activeTabIndex].navigationModel = self.webViewTab.currentNavigationModel
            completion?()
        }
    }
    
    private func changeToTab(atIndex index:Int) {
        guard index >= 0 && index < self.webTabs.count,
              let navigationModel = self.webTabs[index].navigationModel else {
            return
        }
        
        self.activeTabIndex = index
        self.webViewTab.changeNavigationModel(to: navigationModel)
        
    }
    
    private func removeTabAt(index: Int){
        guard index >= 0 && index < self.webTabs.count else {
            return
        }
        
        let activeIndexBeforeChange = self.activeTabIndex
        
        self.webTabs.remove(at: index)
        if index <= self.activeTabIndex {
            self.activeTabIndex -= 1
        }
        
        if self.activeTabIndex < 0 {
            self.activeTabIndex = 0;
        }
        
        if self.webTabs.count == 0 {
            self.addNewTab()
        }
        
        if activeIndexBeforeChange != self.activeTabIndex {
            self.changeToTab(atIndex: self.activeTabIndex)
        }
    }
    
    //MARK:
    
    private func callbacksForWebView() -> UIWebViewTabCallbacks? {
        weak var weakSelf = self
        return UIWebViewTabCallbacks(whenUserChoosesToViewTabs: {
            weakSelf?.bringToFrontWebViewTabs()
        }, urlForUserInput: { string in
            let searchURL = queryURLPart + (string.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? "")
            return URL(string: searchURL)!
        })
    }
    
    //MARK:
    
    private func bringToFrontWebViewTabs() {
        
        self.webViewTab.createDescriptionWithCompletionHandler { desc in
            
            self.webTabs[self.activeTabIndex].webTabDescription = desc
            let items = self.webTabs.flatMap { (wt) -> WebTabDescription? in
                return wt.webTabDescription
            }
            let callbacks = self.callbacksForWebTabsView()
            
            self.webTabsView.setupWith(webTabs: items, callbacks: callbacks)
            self.setTabsViewTopConstraint(to: 0, animated: true)
        }
        
    }
    
    private func setTabsViewTopConstraint(to value: CGFloat, animated: Bool = false) {
        self.webTabsViewTopCn.constant = value;
        self.view.setNeedsLayout()
        let block: VoidBlock = {
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: block, completion: nil)
        } else {
            block()
        }
    }
    
    
    private func callbacksForWebTabsView() -> UIWebTabsViewCallbacks? {
        weak var weakSelf = self
        
        let closeWebTabsView: VoidBlock = {
            weakSelf?.setTabsViewTopConstraint(to: UIScreen.main.bounds.size.height, animated: true)
        }
        
        let whenUserAddsNewTab: VoidBlock = {
            weakSelf?.saveCurrentTabStateWithCompletion {
                weakSelf?.addNewTab()
                weakSelf?.changeToTab(atIndex: (weakSelf?.webTabs.count ?? 0) - 1)
                closeWebTabsView()
                
            }
        }
        
        let whenUserSelectsTab: ((_ index: Int) -> Void)? = { index in
            weakSelf?.saveCurrentTabStateWithCompletion{
                weakSelf?.changeToTab(atIndex: index)
                closeWebTabsView()
            }
        }
        
        let whenUserDeletesTab: ((_ index: Int) -> Void)? = { index in
            weakSelf?.removeTabAt(index: index)
        }
        
        return UIWebTabsViewCallbacks(whenUserPressedClose: closeWebTabsView, whenUserAddsNewTab: whenUserAddsNewTab, whenUserSelectedTabAtIndex: whenUserSelectsTab, whenUserDeletedTabAtIndex: whenUserDeletesTab)
    }
}
