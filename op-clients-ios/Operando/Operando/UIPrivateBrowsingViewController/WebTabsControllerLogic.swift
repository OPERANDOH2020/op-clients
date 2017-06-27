//
//  WebTabsControllerLogic.swift
//  Operando
//
//  Created by Costin Andronache on 3/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit

typealias WebViewVisibilityModifier = (_ webTab: UIWebViewTab, _ animated: Bool, _ completion: VoidBlock?) -> Void
typealias WebTabsViewVisibilityModifier = (_ webTabsView: UIWebTabsListView, _ animated: Bool, _ completion: VoidBlock?) -> Void

struct WebTabsControllerLogicCallbacks {
    let hideWebViewTabCallback: WebViewVisibilityModifier?
    let showWebViewTabCallback: WebViewVisibilityModifier?
    let hideWebTabsView: WebTabsViewVisibilityModifier?
    let showWebTabsViewOnTop: WebTabsViewVisibilityModifier?
    let addNewWebViewTabCallback: (() -> UIWebViewTab)?
    let presentAlertController: ((_ alertController: UIAlertController) -> Void)?
}

struct WebTabsControllerLogicModel {
    let webTabsView: UIWebTabsListView
    let maxNumberOfReusableWebViews: Int
    let webPool: WebViewTabManagementPool
}




class WebTabsControllerLogic: NSObject {
    
    private let model: WebTabsControllerLogicModel
    private let callbacks: WebTabsControllerLogicCallbacks
    
    private let sharedProcessPool = WKProcessPool()
    private var webTabs: [WebTab] = []
    private var indexOfTabAssociatedWithWebView: [UIWebViewTab: Int] = [:]
    
    private var activeTabIndex: Int = -1;
    private var activeWebViewTab: UIWebViewTab? {
        return self.webViewAssociatedWithTab(at: self.activeTabIndex)
    }
    private var canCreateNewWebViewTab: Bool {
        return self.model.webPool.allWebViewTabs.count < self.model.maxNumberOfReusableWebViews
    }
    
    //MARK: 
    
    
    init(model: WebTabsControllerLogicModel, callbacks: WebTabsControllerLogicCallbacks) {
        self.model = model
        self.callbacks = callbacks
        super.init()
        
        
        self.addNewDefaultTab()
        self.activeTabIndex = 0;
        
        if let webViewTab = callbacks.addNewWebViewTabCallback?() {
            let webViewTabModel = UIWebViewTabNewWebViewModel(navigationModel: self.webTabs[self.activeTabIndex].navigationModel, processPool: self.sharedProcessPool)
            
            webViewTab.setupWith(model: webViewTabModel, callbacks: self.callbacksForWebView())
            self.model.webPool.addNew(webViewTab: webViewTab)
            self.indexOfTabAssociatedWithWebView[webViewTab] = self.activeTabIndex
        }
        
    }
    private func webViewAssociatedWithTab(at index: Int) -> UIWebViewTab? {
        guard let wtvIndex = self.model.webPool.allWebViewTabs.index(where:{self.indexOfTabAssociatedWithWebView[$0] == index}) else {
            return nil
        }
        
        return self.model.webPool.allWebViewTabs[wtvIndex]
    }
    
    private func reusedWebViewTabForTab(at index: Int, in callback: @escaping (_ wv: UIWebViewTab?) -> Void) {
        guard index >= 0 && index < self.webTabs.count else {
            callback(nil)
            return
        }
    
        if let existingWV = self.webViewAssociatedWithTab(at: index) {
           self.model.webPool.markWebViewTab(existingWV)
           callback(existingWV)
            return
        }
        
        if self.canCreateNewWebViewTab,
            let webViewTab = callbacks.addNewWebViewTabCallback?() {
            let webViewTabModel = UIWebViewTabNewWebViewModel(navigationModel: self.webTabs[index].navigationModel, processPool: self.sharedProcessPool)
            
            webViewTab.setupWith(model: webViewTabModel, callbacks: self.callbacksForWebView())
            self.model.webPool.addNew(webViewTab: webViewTab)
            callback(webViewTab)
            return
        }
        
        if let navigationModel = self.webTabs[index].navigationModel,
            let reusedWebView = self.model.webPool.oldestWebViewTab {
            self.model.webPool.markWebViewTab(reusedWebView)
            reusedWebView.changeNavigationModel(to: navigationModel, callback: {
                callback(reusedWebView)
            })
            return
        }
        
        callback(nil)
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
    
    private func addNewDefaultTab() {
        let newTab = self.createDefaultWebTab()
        self.webTabs.append(newTab)
    }
    
    private func saveCurrentTabStateWithCompletion(_ completion: VoidBlock?) {
        self.activeWebViewTab?.createDescriptionWithCompletionHandler { description in
            self.webTabs[self.activeTabIndex].webTabDescription = description
            self.webTabs[self.activeTabIndex].navigationModel = self.activeWebViewTab?.currentNavigationModel
            completion?()
        }
    }
    
    
    private func decrementWebViewIndexesGreater(than index: Int) {
        let allWebViews = self.model.webPool.allWebViewTabs
        for wv in allWebViews {
            if let wvTabIndex = self.indexOfTabAssociatedWithWebView[wv], wvTabIndex > index {
                self.indexOfTabAssociatedWithWebView[wv] = wvTabIndex - 1
            }
        }
    }
    
    private func removeTabAt(index: Int){
        guard index >= 0 && index < self.webTabs.count else {
            return
        }
        
        if let webViewForThatTab = self.webViewAssociatedWithTab(at: index) {
            self.indexOfTabAssociatedWithWebView[webViewForThatTab] = nil
        }
        
        self.webTabs.remove(at: index)
        self.decrementWebViewIndexesGreater(than: index)
        
        if index > self.activeTabIndex {
            return
        }
        
        let activeIndexBeforeChange = self.activeTabIndex
        
        self.activeTabIndex -= 1
        if self.activeTabIndex < 0 {
            self.activeTabIndex = 0;
        }
        
        if self.webTabs.count == 0 {
            self.addNewDefaultTab()
        }
        
        if activeIndexBeforeChange != self.activeTabIndex ||
            activeIndexBeforeChange == index {
            self.changeToTab(atIndex: self.activeTabIndex, callback: nil)
        }
    }
    
    private func changeToTab(atIndex index: Int, callback: VoidBlock?) {
        guard index >= 0 && index < self.webTabs.count else {
            callback?()
            return
        }
        
        if let currentActiveWebView = self.activeWebViewTab {
            self.callbacks.hideWebViewTabCallback?(currentActiveWebView, false, nil);
        }
        
        self.reusedWebViewTabForTab(at: index) { webTabView in
            guard let webTabView = webTabView else {
                callback?()
                return
            }
            
            self.activeTabIndex = index
            self.indexOfTabAssociatedWithWebView[webTabView] = index
            self.callbacks.showWebViewTabCallback?(webTabView, false, nil)
            callback?()
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
        }, whenPresentingAlertController: self.callbacks.presentAlertController,
           whenCreatingExternalWebView: { configuration, action in
            guard let tabView = weakSelf?.callbacks.addNewWebViewTabCallback?(),
                  let newWebTab = weakSelf?.createDefaultWebTab() else {
                return nil
            }
            
            weakSelf?.activeWebViewTab?.activityIndicator.isHidden = false
            
            let webView = WKWebView(frame: .zero, configuration: configuration)
            weakSelf?.activeWebViewTab?.createDescriptionWithCompletionHandler({ description in
                weakSelf?.webTabs[weakSelf?.activeTabIndex ?? 0].webTabDescription = description
                
                weakSelf?.activeWebViewTab?.activityIndicator.isHidden = true 
                
                weakSelf?.webTabs.append(newWebTab)
                
                let model = UIWebViewTabExistingWebViewModel(webView: webView)
                tabView.setupWith(model: model, callbacks: self.callbacksForWebView())
                weakSelf?.model.webPool.addNew(webViewTab: tabView)
                
                let index = (weakSelf?.webTabs.count ?? 0) - 1
                weakSelf?.activeTabIndex = index
                weakSelf?.indexOfTabAssociatedWithWebView[tabView] = index
                weakSelf?.callbacks.showWebViewTabCallback?(tabView, false, nil)
            })
            
            return webView
        });
    }
    
    //MARK:
    
    private func bringToFrontWebViewTabs() {
        
        self.activeWebViewTab?.createDescriptionWithCompletionHandler { desc in
            
            self.webTabs[self.activeTabIndex].webTabDescription = desc
            let items = self.webTabs.flatMap { (wt) -> WebTabDescription? in
                return wt.webTabDescription
            }
            let callbacks = self.callbacksForWebTabsView(self.model.webTabsView)
            
            self.model.webTabsView.setupWith(webTabs: items, callbacks: callbacks)
            self.callbacks.showWebTabsViewOnTop?(self.model.webTabsView, true, nil)
        }
        
    }
    

    
    private func callbacksForWebTabsView(_ webTabsView: UIWebTabsListView) -> UIWebTabsViewCallbacks? {
        weak var weakSelf = self
        weak var weakTabsView = webTabsView
        
        let closeWebTabsView: VoidBlock = {
            guard let tabsView = weakTabsView else {
                return
            }
            tabsView.inBusyState = false
            weakSelf?.callbacks.hideWebTabsView?(tabsView, false, nil)
        }
        
        let whenUserAddsNewTab: VoidBlock = {
            weakTabsView?.inBusyState = true
            
            weakSelf?.saveCurrentTabStateWithCompletion {
                weakSelf?.addNewDefaultTab()
                weakSelf?.changeToTab(atIndex: (weakSelf?.webTabs.count ?? 0) - 1, callback: closeWebTabsView)
            }
        }
        
        let whenUserSelectsTab: ((_ index: Int) -> Void)? = { index in
            weakTabsView?.inBusyState = true
            weakSelf?.saveCurrentTabStateWithCompletion{
                weakSelf?.changeToTab(atIndex: index, callback: closeWebTabsView)
            }
        }
        
        let whenUserDeletesTab: ((_ index: Int) -> Void)? = { index in
            weakSelf?.removeTabAt(index: index)
        }
        
        return UIWebTabsViewCallbacks(whenUserPressedClose: closeWebTabsView, whenUserAddsNewTab: whenUserAddsNewTab, whenUserSelectedTabAtIndex: whenUserSelectsTab, whenUserDeletedTabAtIndex: whenUserDeletesTab)
    }

}