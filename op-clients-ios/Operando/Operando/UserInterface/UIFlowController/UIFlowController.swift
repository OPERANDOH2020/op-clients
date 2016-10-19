//
//  UIFlowController.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct Dependencies{
    let identityManagementRepo: IdentitiesManagementRepository
    let privacyForBenefitsRepo: PrivacyForBenefitsRepository
    let userInfoRepo: UserInfoRepository
}

class UIFlowController
{
    let dependencies: Dependencies
    let rootController: UIRootViewController
    let slidingViewController: ECSlidingViewController
    
    init(dependencies: Dependencies)
    {
        self.dependencies = dependencies
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
    
    
    func displayDashboard(){
        let dashBoardVC = UINavigationManager.dashboardViewController
        
        weak var weakSelf = self
        
        let dashboardCallbacks = UIDashBoardViewControllerCallbacks(whenChoosingIdentitiesManagement: { 
             weakSelf?.displayIdentitiesManagement()
            },whenChoosingPrivacyForBenefits: {
              weakSelf?.displayPfbDeals()
            },whenChoosingPrivateBrowsing: {
              weakSelf?.displayPrivateBrowsing()
            },
              whenChoosingNotifications: nil)
        
        dashBoardVC.setupWith(callbacks: dashboardCallbacks)
        self.rootController.setMainControllerTo(newController: dashBoardVC)
    }
    
    
    
    func displayIdentitiesManagement(){
        let vc = UINavigationManager.identityManagementViewController
        vc.setupWith(identitiesRepository: dependencies.identityManagementRepo)
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayPfbDeals() {
        let vc = UINavigationManager.pfbDealsController
        vc.setupWith(dealsRepository: dependencies.privacyForBenefitsRepo)
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayPrivateBrowsing() {
        let vc = UINavigationManager.privateBrowsingViewController
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func setupBaseHierarchyInWindow(_ window: UIWindow){
        window.rootViewController = self.slidingViewController
    }
}