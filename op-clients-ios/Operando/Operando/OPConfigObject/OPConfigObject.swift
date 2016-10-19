//
//  OPConfigObject.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class OPConfigObject: NSObject
{
    private let dependencies: Dependencies
    static let sharedInstance = OPConfigObject()
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private let userRepository: UsersRepository
    private let flowController: UIFlowController
    
    override init()
    {
        self.userRepository = self.swarmClientHelper
        self.dependencies = Dependencies(identityManagementRepo: self.swarmClientHelper, privacyForBenefitsRepo: self.swarmClientHelper, userInfoRepo: self.swarmClientHelper)
        self.flowController = UIFlowController(dependencies: self.dependencies)
        super.init()
    }
    
    func getCurrentUserIdentityIfAny() -> UserIdentityModel?
    {
        return self.currentUserIdentity
    }
    
    func applicationDidStart(inWindow window: UIWindow) {
        let sideMenu = SSASideMenu(contentViewController: UINavigationManager.rootViewController, leftMenuViewController: UINavigationManager.leftMenuViewController)
        sideMenu.configure(configuration: SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false, parallaxEnabled: true, bouncesHorizontally: false, statusBarStyle: SSASideMenu.SSAStatusBarStyle.Black))
        window.rootViewController = sideMenu
    }
    
    func applicationDidStartInWindow(window: UIWindow)
    {
        
        self.flowController.setupBaseHierarchyInWindow(window)
        
        weak var weakSelf = self
        if let (username, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.userRepository.loginWithUsername(username: username, password: password, withCompletion: { (error, data) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let error = error
                {
                    OPErrorContainer.displayError(error: error)
                    weakSelf?.flowController.displayLoginHierarchyWith(loginCallback: { loginInfo in
                        weakSelf?.logiWithInfoAndUpdateUI(loginInfo)
                    })
                    return
                }
                
                weakSelf?.dependencies.userInfoRepo.getCurrentUserInfo(in: { info, error  in
                    print(error)
                })
                
                weakSelf?.currentUserIdentity = data
                weakSelf?.flowController.setupHierarchyStartingWithDashboardIn(window)
            })
        }
        else
        {
            weakSelf?.flowController.displayLoginHierarchyWith(loginCallback: { loginInfo in
                weakSelf?.logiWithInfoAndUpdateUI(loginInfo)
            })
        }
    }
    
    
    func logiWithInfoAndUpdateUI(_ loginInfo: LoginInfo)
    {
        weak var weakSelf = self
        self.userRepository.loginWithUsername(username: loginInfo.username, password: loginInfo.password) { (error, data) in
            
            if let error = error
            {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if loginInfo.wishesToBeRemembered
            {
                CredentialsStore.saveCredentials(username: loginInfo.username, password: loginInfo.password)
            }
            
            weakSelf?.currentUserIdentity = data
            weakSelf?.flowController.displayDashboard()
        }
    }
}
