//
//  UIRootViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIRootViewController: UIViewController
{
    
    @IBOutlet weak var blackAlphaView: UIView!
    @IBOutlet weak var mainScreensHostView: UIView!
    @IBOutlet weak var menuViewControllerHostLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuViewControllerHostView: UIView!
    var menuViewController: UIMenuTableViewController?
    
    private var mainNavController: UINavigationController?
    
    
    
    func beginDisplayingUI()
    {
        let _ = self.view;

        self.blackAlphaView.isHidden = false;
        self.blackAlphaView.alpha = 0.0;
        
        self.mainNavController = self.loadAndSetupMainNavigationController();
        self.loadAndSetupMenuViewController();
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event);
        self.hideMenu();
    }
    
    @IBAction func didPressMenuButton(sender: AnyObject)
    {
        self.displayMenu();
    }

    
    func animateMenuSpaceConstraintTo(value: CGFloat)
    {
        self.menuViewControllerHostLeadingSpace.constant = value;
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { 
            self.view.layoutIfNeeded();
            }, completion: nil);
    }
    
    
    private func displayMenu()
    {
        self.menuViewController?.refreshViewWithUsername(username: OPConfigObject.sharedInstance.getCurrentUserIdentityIfAny()?.username)
        self.animateBlackViewAlphaTo(newAlpha: 0.5)
        self.animateMenuSpaceConstraintTo(value: 0);
    }
    
    private func hideMenu()
    {
        self.animateBlackViewAlphaTo(newAlpha: 0.0);
        self.animateMenuSpaceConstraintTo(value: -self.view.frame.size.width * 1.2);
    }
    
    
    private func animateBlackViewAlphaTo(newAlpha: CGFloat)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { 
            self.blackAlphaView.alpha = newAlpha;
            }, completion: nil);
    }
    
    private func loadAndSetupMenuViewController()
    {
        let menuVC = UINavigationManager.menuViewController;
        menuVC.actionsPerIndex = self.actionsForMenuController();
        self.addContentController(controller: menuVC, constrainWithAutolayout: true, inOwnViewSubview: self.menuViewControllerHostView);
        self.menuViewController = menuVC
    }
    
    private func loadAndSetupMainNavigationController() -> UINavigationController
    {
        let navController = UINavigationManager.mainNavigationController;
        self.addContentController(controller: navController, constrainWithAutolayout: true, inOwnViewSubview: self.mainScreensHostView);
        
        if let rootNavController = navController.viewControllers.first as? UIDashboardViewController
        {
            weak var weakSelf = self
            rootNavController.whenPrivateBrowsingButtonPressed = {
                weakSelf?.loadPrivateBrowsingAsMainViewController()
            }
        }
        
        return navController
    }
    
    
    private func setMainControllerTo(newController: UIViewController, navigationBarHidden : Bool = false)
    {
        UIView.performWithoutAnimation {
            self.mainNavController?.isNavigationBarHidden = navigationBarHidden
            self.mainNavController?.viewControllers = [newController];
        }
        self.hideMenu()
    }
    
    
    
    private func actionsForMenuController() -> [Int : VoidBlock]
    {
        weak var weakSelf = self;
        return [2: {weakSelf?.setMainControllerTo(newController: UINavigationManager.snSettingsReaderViewController)},
                3: {weakSelf?.setMainControllerTo(newController: UINavigationManager.dataLeakageViewController)},
                0: {weakSelf?.loadDashboardAsMainViewController()},
                8: {weakSelf?.setMainControllerTo(newController: UINavigationManager.identityManagementViewController)},
                4: {weakSelf?.setMainControllerTo(newController: UINavigationManager.notificationsViewController)},
                6: {weakSelf?.loadPrivateBrowsingAsMainViewController()},
                1: {weakSelf?.setMainControllerTo(newController: UINavigationManager.snSettingsReaderViewController)}
        ];
    }
    
    //MARK: - View controller load methods
    
    private func loadDashboardAsMainViewController()
    {
        let vc = UINavigationManager.dashboardViewController
        weak var weakSelf = self
        vc.whenPrivateBrowsingButtonPressed = {
            weakSelf?.loadPrivateBrowsingAsMainViewController()
        }
        
        self.setMainControllerTo(newController: vc)
    }
    
    private func loadPrivateBrowsingAsMainViewController()
    {
        self.setMainControllerTo(newController: UINavigationManager.privateBrowsingViewController, navigationBarHidden: true)
    }
}
