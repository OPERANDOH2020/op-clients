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
    static let sharedInstance = OPConfigObject()
    
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private let flowController = UIFlowController()
    
    
    func getCurrentUserIdentityIfAny() -> UserIdentityModel?
    {
        return self.currentUserIdentity
    }
    

    
    func applicationDidStartInWindow(window: UIWindow)
    {
        
        self.flowController.setupBaseHierarchyInWindow(window)
        
        weak var weakSelf = self
        if let (username, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            self.swarmClientHelper.loginWithUsername(username: username, password: password, withCompletion: { (error, data) in
                if let error = error
                {
                    OPErrorContainer.displayError(error: error)
                    weakSelf?.flowController.displayLoginHierarchyWith(loginCallback: { loginInfo in
                        weakSelf?.logiWithInfoAndUpdateUI(loginInfo)
                    })
                    
                    
                    return
                }
                
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
        self.swarmClientHelper.loginWithUsername(username: loginInfo.username, password: loginInfo.password) { (error, data) in
            
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
