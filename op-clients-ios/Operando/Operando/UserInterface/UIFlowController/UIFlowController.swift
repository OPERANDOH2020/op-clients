//
//  UIFlowController.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

typealias NotificationActionCallback = (_ action: String, _ notification: OPNotification) -> Void

struct Dependencies{
    let identityManagementRepo: IdentitiesManagementRepository
    let privacyForBenefitsRepo: PrivacyForBenefitsRepository
    let userInfoRepo: UserInfoRepository
    let notificationsRepository: NotificationsRepository
    let whenCallingToLogout: VoidBlock?
    let whenTakingActionForNotification: NotificationActionCallback?
}

class UIFlowController
{
    let dependencies: Dependencies
    let rootController: UIRootViewController
    private var sideMenu: SSASideMenu?
    
    init(dependencies: Dependencies)
    {
        self.dependencies = dependencies
        self.rootController = UINavigationManager.rootViewController
        
        weak var weakSelf = self
        let rootControllerCallbacks = UIRootViewControllerCallbacks(whenMenuButtonPressed: {
            weakSelf?.sideMenu?._presentLeftMenuViewController()
            }, whenAccountButtonPressed: {
                weakSelf?.sideMenu?._presentRightMenuViewController()
        })
        
        self.rootController.setupWithCallbacks(rootControllerCallbacks)
    }
    
    func setSideMenu(enabled: Bool) {
        if enabled {
            sideMenu?.leftMenuViewController = getLeftSideMenuViewController()
            sideMenu?.rightMenuViewController = getRightMenuViewController()
        } else {
            sideMenu?.leftMenuViewController = nil
            sideMenu?.rightMenuViewController = nil
        }
    }
    
    func displayLoginHierarchyWith(loginCallback: LoginCallback?, registerCallback: RegistrationCallback?)
    {
        self.sideMenu?.hideMenuViewController()
        
        let loginVC = UINavigationManager.loginViewController
        let registrationViewController = UINavigationManager.registerViewController
        weak var weakLoginVC = loginVC
        
        let loginViewControllerCallbacks = UISignInViewControllerCallbacks(whenUserWantsToLogin: loginCallback) {
            weakLoginVC?.navigationController?.pushViewController(registrationViewController, animated: true)
        }
        
        let registerViewControllerCallbacks = UIRegistrationViewControllerCallbacks(whenUserRegisters: registerCallback) { 
            weakLoginVC?.navigationController?.popViewController(animated: true)
        }
        
        loginVC.setupWithCallbacks(loginViewControllerCallbacks)
        registrationViewController.setupWith(callbacks: registerViewControllerCallbacks)
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.isNavigationBarHidden = true
        
        self.rootController.setMainControllerTo(newController: navigationController)
    }
    
    private func createRegisterViewController() -> UIRegistrationViewController {
        return UINavigationManager.registerViewController
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
              whenChoosingNotifications: {
              weakSelf?.displayNotifications()
        })
        
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
    
    
    func displayNotifications() {
        let vc = UINavigationManager.notificationsViewController
        
        vc.setup(with: self.dependencies.notificationsRepository, notificationCallback: self.dependencies.whenTakingActionForNotification)
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func setupBaseHierarchyInWindow(_ window: UIWindow){
        let sideMenu = SSASideMenu(contentViewController: self.rootController, leftMenuViewController: getLeftSideMenuViewController())
        sideMenu.configure(configuration: SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false, parallaxEnabled: true, bouncesHorizontally: false, statusBarStyle: SSASideMenu.SSAStatusBarStyle.Black))
        window.rootViewController = sideMenu
        self.sideMenu = sideMenu
    }
    
    
    
    
    private func getRightMenuViewController() -> UIAccountViewController {
        
        let accountController = UINavigationManager.accountViewController
        accountController.setupWith(model: UIAccountViewControllerModel(repository: self.dependencies.userInfoRepo, whenUserChoosesToLogout: self.dependencies.whenCallingToLogout))
        
        return accountController
    }
    
    
    private func getLeftSideMenuViewController() -> UILeftSideMenuViewController {
        let leftSideMenu = UINavigationManager.leftMenuViewController
        leftSideMenu.callbacks = getLeftSideMenuCallbacks()
        return leftSideMenu
    }
    

    
    private func getLeftSideMenuCallbacks() -> UIDashBoardViewControllerCallbacks {
        return UIDashBoardViewControllerCallbacks(whenChoosingIdentitiesManagement: { [unowned self] in
                self.displayIdentitiesManagement()
                self.sideMenu?.hideMenuViewController()
            },whenChoosingPrivacyForBenefits: {
                self.displayPfbDeals()
                self.sideMenu?.hideMenuViewController()
            },whenChoosingPrivateBrowsing: {
                self.displayPrivateBrowsing()
                self.sideMenu?.hideMenuViewController()
            },
              whenChoosingNotifications: {
                self.displayNotifications()
                self.sideMenu?.hideMenuViewController()
        })
    }
}
