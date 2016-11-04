//
//  OPConfigObject.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kPleaseConfirmEmailLocalizableKey = "kPleaseConfirmEmailLocalizableKey"
let kPleaseCheckEmailResetLocalizableKey = "kPleaseCheckEmailResetLocalizableKey"
let kPasswordChangedSuccesfullyLocalizableKey = "kPasswordChangedSuccesfullyLocalizableKey"

enum NotificationAction: String {
    case identitiesMangament = "identitiesMangament"
    case privacyForBenefits = "privacyForBenefits"
    case privateBrowsing = "privateBrowsing"
}

class OPConfigObject: NSObject
{
    static let sharedInstance = OPConfigObject()
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private var userRepository: UsersRepository?
    private var flowController: UIFlowController?
    private var dependencies: Dependencies?
    private var actionsPerNotificationType: [String: VoidBlock] = [:]
    


    private func initPropertiesOnAppStart() {
        
        self.userRepository = self.swarmClientHelper
        let dependencies = Dependencies(identityManagementRepo:  self.swarmClientHelper,
                                         privacyForBenefitsRepo:  self.swarmClientHelper,
                                         userInfoRepo:            self.swarmClientHelper,
                                         notificationsRepository: DummyNotificationsRepo(),//self.swarmClientHelper,
            accountCallbacks: self.createAccountCallbacks(),
            whenTakingActionForNotification: { OPConfigObject.sharedInstance.dismiss(notification: $1, andTakeAction: $0) }
        )
        
        self.flowController = UIFlowController(dependencies: dependencies)
        self.dependencies = dependencies
        
        weak var flowCntroler = self.flowController
        
        self.actionsPerNotificationType = [NotificationAction.identitiesMangament.rawValue:
            {flowCntroler?.displayIdentitiesManagement()},
                                           NotificationAction.privateBrowsing.rawValue:
                                            {flowCntroler?.displayPrivateBrowsing()},
                                           NotificationAction.privacyForBenefits.rawValue:
                                            {flowCntroler?.displayPfbDeals()}]
    }
    
    
    func applicationDidStartInWindow(window: UIWindow)
    {
        self.initPropertiesOnAppStart()
        self.flowController?.setupBaseHierarchyInWindow(window)
        
        flowController?.setSideMenu(enabled: false)
        weak var weakSelf = self
        if let (username, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.userRepository?.loginWithUsername(username: username, password: password, withCompletion: { (error, data) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let error = error
                {
                    OPErrorContainer.displayError(error: error)
                    weakSelf?.flowController?.displayLoginHierarchy()
                    return
                }
                
                weakSelf?.currentUserIdentity = data
                weakSelf?.flowController?.setupHierarchyStartingWithDashboardIn(window)
                weakSelf?.flowController?.setSideMenu(enabled: true)
            })
        }
        else
        {
            weakSelf?.flowController?.displayLoginHierarchy()
            
        }
    }
    
    
    private func logiWithInfoAndUpdateUI(_ loginInfo: LoginInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weak var weakSelf = self
        self.userRepository?.loginWithUsername(username: loginInfo.username, password: loginInfo.password) { (error, data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if loginInfo.wishesToBeRemembered {
                if let error = CredentialsStore.saveCredentials(username: loginInfo.username, password: loginInfo.password){
                    OPErrorContainer.displayError(error: error)
                }
            }
            
            weakSelf?.afterLoggingInWith(identity: data)
        }
    }
    
    
    private func registerWithInfoAndUpdateUI(_ info: RegistrationInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.userRepository?.registerNewUserWith(username: info.username, email: info.email, password: info.password) { error in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            OPViewUtils.displayAlertWithMessage(message: Bundle.localizedStringFor(key: kPleaseConfirmEmailLocalizableKey), withTitle: "", addCancelAction: false, withConfirmation: nil)
        }
        
    }
    
    private func afterLoggingInWith(identity: UserIdentityModel){
        self.currentUserIdentity = identity
        self.flowController?.displayDashboard()
        self.flowController?.setSideMenu(enabled: true)
    }
    
    
    private func logoutUserAndUpdateUI(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.userRepository?.logoutUserWith { error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            
            if let error = CredentialsStore.deleteCredentials() {
                OPErrorContainer.displayError(error: error)
            }
            
            self.flowController?.setSideMenu(enabled: false)
            self.flowController?.displayLoginHierarchy()
        }
    }
    
    private func dismiss(notification: OPNotification, andTakeAction action: String){
        
        self.dependencies?.notificationsRepository.dismiss(notification: notification) { error in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            if let action = self.actionsPerNotificationType[action] {
                action()
            } else {
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "Will be available soon")
            }
            
        }
        
    }
    
    private func resetPasswordAndUpdateUIFor(email: String) {
        self.userRepository?.resetPasswordFor(email: email) { error in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: Bundle.localizedStringFor(key: Bundle.localizedStringFor(key: kPleaseCheckEmailResetLocalizableKey)))
        }
    }
    
    private func createPasswordChangeCallback() -> PasswordChangeCallback {
        weak var weakSelf = self
        
        return { oldPassword, newPassword, successCallback in
            
            weakSelf?.userRepository?.changeCurrent(password: oldPassword, to: newPassword, withCompletion: { error in
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: Bundle.localizedStringFor(key: kPasswordChangedSuccesfullyLocalizableKey))
                if let error = CredentialsStore.updatePassword(to: newPassword) {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                successCallback?()
            })
            
        }
        
    }
    
    private func createAccountCallbacks() -> AccountCallbacks {
        
        weak var weakSelf = self

        return AccountCallbacks(loginCallback: { info in
            weakSelf?.logiWithInfoAndUpdateUI(info)
            }, logoutCallback: { 
                weakSelf?.logoutUserAndUpdateUI()
            },
               registerCallback: { info in
                weakSelf?.registerWithInfoAndUpdateUI(info)
            },
               forgotPasswordCallback: { email in
                weakSelf?.resetPasswordAndUpdateUIFor(email: email)
        }, passwordChangeCallback: weakSelf?.createPasswordChangeCallback())
        
        
    }
    
}
