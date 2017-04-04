//
//  WebTabsControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class WebTabsControllerLogicTests: XCTestCase {
    
    
    func testOnInitCreatesFirstTab() {
        let expectation = self.expectation(description: "On init the logic should create it's first tab and ask for a view for it")
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil) { () -> UIWebViewTab in
            expectation.fulfill()
            return UIWebViewTab(frame: .zero)
        }
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsView: DummyWebTabsView(), maxNumberOfReusableWebViews: 1, webPool: WebViewTabManagementPool())
        
        let _: WebTabsControllerLogic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    

    
}
