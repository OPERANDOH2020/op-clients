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
    
    
    func getCurrentUserIdentityIfAny() -> UserIdentityModel?
    {
        return self.currentUserIdentity
    }
    

    
    func applicationDidStartInWindow(window: UIWindow)
    {
        let rootController = UINavigationManager.rootViewController;
        window.rootViewController = rootController
        

        if let (username, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            weak var weakSelf = self
            self.swarmClientHelper.loginWithUsername(username: username, password: password, withCompletion: { (error, data) in
                defer
                {
                    rootController.beginDisplayingUI()
                }
                
                guard error == nil else {return}
                weakSelf?.currentUserIdentity = UserIdentityModel(username: username, password: password)
            })
        }
        else
        {
            rootController.beginDisplayingUI()
        }
    }
    
    
    func loginUserWithInfo(loginInfo: LoginInfo, withCompletion completion: @escaping ((_ error: NSError?, _ identity: UserIdentityModel?) -> Void))
    {
        weak var weakSelf = self
        self.swarmClientHelper.loginWithUsername(username: loginInfo.username, password: loginInfo.password) { (error, data) in
            guard error == nil else
            {
                completion(error, nil)
                return;
            }
            
            if loginInfo.wishesToBeRemembered
            {
                CredentialsStore.saveCredentials(username: loginInfo.username, password: loginInfo.password)
            }
            
            weakSelf?.currentUserIdentity = UserIdentityModel(username: loginInfo.username, password: loginInfo.password);
            completion(nil, weakSelf?.currentUserIdentity)
            
        }
    }
}
