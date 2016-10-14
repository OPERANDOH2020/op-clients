//
//  UIFlowController.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


class UIFlowController
{
    
    let rootController: UIRootViewController
    let slidingViewController: ECSlidingViewController
    
    init()
    {
        self.rootController = UINavigationManager.rootViewController
        
        self.slidingViewController = ECSlidingViewController(topViewController: self.rootController)
        self.slidingViewController.underLeftViewController = UINavigationManager.menuViewController
        
        weak var weakSlidingController = self.slidingViewController
        let rootControllerCallbacks = UIRootViewControllerCallbacks(whenMenuButtonPressed: {
            
            weakSlidingController?.anchorTopViewToRight(animated: true)
            }, whenAccountButtonPressed: nil)
        
        self.rootController.setupWithCallbacks(rootControllerCallbacks)
    
        
    }
    
    
    func displayLoginHierarchyWith(loginCallback: LoginCallback?)
    {
        let loginVC = UINavigationManager.loginViewController
        let callbacks = UISignInViewControllerCallbacks(whenUserWantsToLogin: loginCallback) {
            // must push register
        }
        
        loginVC.setupWithCallbacks(callbacks)
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.isNavigationBarHidden = true
        
        self.rootController.setMainControllerTo(newController: navigationController)
    }
    
    
    func setupHierarchyStartingWithDashboardIn(_ window: UIWindow)
    {
        self.setupBaseHierarchyInWindow(window)
        self.displayDashboard()
    }
    
    
    func displayDashboard()
    {
        let dashBoardVC = UINavigationManager.dashboardViewController
        self.rootController.setMainControllerTo(newController: dashBoardVC)
    }
    
    
    func setupBaseHierarchyInWindow(_ window: UIWindow)
    {
        window.rootViewController = self.slidingViewController
    }
}
