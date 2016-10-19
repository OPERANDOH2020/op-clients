//
//  UINavigationManager.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

class UINavigationManager
{
    static let main = UIStoryboard(name: "Main", bundle: nil);
    static let utility = UIStoryboard(name: "UtilityControllers", bundle: nil)
    static let leftMenu = UIStoryboard(name: "LeftMenu", bundle: nil)
    
    static var rootViewController : UIRootViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIRootViewController") as! UIRootViewController
        }
    }
    
    static var menuViewController : UIMenuTableViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIMenuTableViewController") as! UIMenuTableViewController
        }
    }
    
    static var mainNavigationController : UINavigationController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController;
        }
    }
    
    static var sensorMonitoringViewController: UISensorMonitoringViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UISensorMonitoringViewController") as! UISensorMonitoringViewController;
        }
    }
    
    static var notificationsViewController: UINotificationsViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UINotificationsViewController") as!
            UINotificationsViewController
        }
    }
    
    static var dataLeakageViewController: UIDataLeakageProtectionViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIDataLeakageProtectionViewController") as! UIDataLeakageProtectionViewController
        }
    }
    
    static var identityManagementViewController : UIIdentityManagementViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIIdentityManagementViewController") as! UIIdentityManagementViewController
        }
    }
    
    static var dashboardViewController: UIDashboardViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIDashboardViewController") as! UIDashboardViewController
        }
    }
    
    
    static var privateBrowsingViewController: UIPrivateBrowsingViewController
    {
        get
        {
            return main.instantiateViewController(withIdentifier: "UIPrivateBrowsingViewController") as! UIPrivateBrowsingViewController
        }
    }
    
    
    
    static var snSettingsReaderViewController: UISNSettingsReaderViewController
    {
        return main.instantiateViewController(withIdentifier: "UISNSettingsReaderViewController") as! UISNSettingsReaderViewController
    }
    
    
    static var loginViewController: UISignInViewController
    {
        return main.instantiateViewController(withIdentifier: "UISignInViewController") as! UISignInViewController
    }
    
    
    static var registerViewController: UIRegistrationViewController
    {
        return main.instantiateViewController(withIdentifier: "UIRegistrationViewController") as! UIRegistrationViewController
    }
    
    
    static var addIdentityController: UIAddIdentityAlertViewController {
        return utility.instantiateViewController(withIdentifier: "UIAddIdentityAlertViewController") as! UIAddIdentityAlertViewController
    }
    
    static var pfbDealsController: UIPfbDealsViewController{
        return main.instantiateViewController(withIdentifier: "UIPfbDealsViewController") as! UIPfbDealsViewController
    }
    
    static var pfbDealDetailsAlertViewController: UIPfbDetailsAlertViewController {
        return utility.instantiateViewController(withIdentifier: "UIPfbDetailsAlertViewController") as! UIPfbDetailsAlertViewController
    }
    
    // MARK: - Left Menu Storyboard
    static var leftMenuViewController: UIViewController {
        return leftMenu.instantiateViewController(withIdentifier: "UILeftSideMenuViewControllerStoryboardId")
    }
    
}
