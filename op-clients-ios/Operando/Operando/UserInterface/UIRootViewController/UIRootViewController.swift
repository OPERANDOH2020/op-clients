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
    
    private var mainNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainNavController = self.loadAndSetupMainNavigationController();
        self.loadAndSetupMenuViewController();
        
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event);
        self.hideMenu();
    }
    
    @IBAction func didPressMenuButton(sender: AnyObject)
    {
        self.displayMenu();
    }

    
    func animateMenuSpaceConstraintTo(value: CGFloat)
    {
        self.menuViewControllerHostLeadingSpace.constant = value;
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { 
            self.view.layoutIfNeeded();
            }, completion: nil);
    }
    
    
    private func displayMenu()
    {
        self.blackAlphaView.hidden = false;
        self.animateMenuSpaceConstraintTo(0);
    }
    
    private func hideMenu()
    {
        self.blackAlphaView.hidden = true;
        self.animateMenuSpaceConstraintTo(-self.view.frame.size.width * 1.2);
    }
    
    
    private func loadAndSetupMenuViewController()
    {
        let menuVC = UINavigationManager.menuViewController;
        menuVC.actionsPerIndex = self.actionsForMenuController();
        self.addContentController(menuVC, constrainWithAutolayout: true, inOwnViewSubview: self.menuViewControllerHostView);
    }
    
    private func loadAndSetupMainNavigationController() -> UINavigationController
    {
        let navController = UINavigationManager.mainNavigationController;
        self.addContentController(navController, constrainWithAutolayout: true, inOwnViewSubview: self.mainScreensHostView);
        
        return navController
    }
    
    
    private func setMainControllerTo(newController: UIViewController)
    {
        UIView.performWithoutAnimation { 
            self.mainNavController?.viewControllers = [newController];
        }
        self.hideMenu()
    }
    
    
    
    private func actionsForMenuController() -> [Int : VoidBlock]
    {
        weak var weakSelf = self;
        return [2: {weakSelf?.setMainControllerTo(UINavigationManager.sensorMonitoringViewController)},
                3: {weakSelf?.setMainControllerTo(UINavigationManager.dataLeakageViewController)},
                0: {weakSelf?.setMainControllerTo(UINavigationManager.dashboardViewController)},
                8: {weakSelf?.setMainControllerTo(UINavigationManager.identityManagementViewController)},
                4: {weakSelf?.setMainControllerTo(UINavigationManager.notificationsViewController)}
        ];
    }
}
