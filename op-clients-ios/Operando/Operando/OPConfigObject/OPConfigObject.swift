//
//  OPConfigObject.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kPleaseConfirmEmailLocalizableKey = "kPleaseConfirmEmailLocalizableKey"

enum NotificationAction: String {
    case identitiesMangament = "identitiesMangament"
    case privacyForBenefits = "privacyForBenefits"
    case privateBrowsing = "privateBrowsing"
}

class OPConfigObject: NSObject
{
    private let dependencies: Dependencies
    static let sharedInstance = OPConfigObject()
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private let userRepository: UsersRepository
    private let flowController: UIFlowController
    
    private let actionsPerNotificationType: [String: VoidBlock]
    
    override init()
    {
        self.userRepository = self.swarmClientHelper
        self.dependencies = Dependencies(identityManagementRepo:  self.swarmClientHelper,
                                         privacyForBenefitsRepo:  self.swarmClientHelper,
                                         userInfoRepo:            self.swarmClientHelper,
                                         notificationsRepository: DummyNotificationsRepo(),//self.swarmClientHelper,
                                         whenCallingToLogout: { OPConfigObject.sharedInstance.logoutUserAndUpdateUI() },
                                         whenTakingActionForNotification: { OPConfigObject.sharedInstance.dismiss(notification: $1, andTakeAction: $0) }
        )
        self.flowController = UIFlowController(dependencies: self.dependencies)
        
        weak var flowCntroler = self.flowController
        
        self.actionsPerNotificationType = [NotificationAction.identitiesMangament.rawValue:
                                              {flowCntroler?.displayIdentitiesManagement()},
                                           NotificationAction.privateBrowsing.rawValue:
                                              {flowCntroler?.displayPrivateBrowsing()},
                                           NotificationAction.privacyForBenefits.rawValue:
                                              {flowCntroler?.displayPfbDeals()}]
        
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
        flowController.setSideMenu(enabled: false)
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
                        }, registerCallback: { registerInfo in
                            weakSelf?.registerWithInfoAndUpdateUI(registerInfo)
                    })
                    return
                }
                
                weakSelf?.currentUserIdentity = data
                weakSelf?.flowController.setupHierarchyStartingWithDashboardIn(window)
                weakSelf?.flowController.setSideMenu(enabled: true)
            })
        }
        else
        {
            weakSelf?.flowController.displayLoginHierarchyWith(loginCallback: { loginInfo in
                weakSelf?.logiWithInfoAndUpdateUI(loginInfo)
                }, registerCallback: { registerInfo in
                    weakSelf?.registerWithInfoAndUpdateUI(registerInfo)
            })
        }
    }
    
    
    private func logiWithInfoAndUpdateUI(_ loginInfo: LoginInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weak var weakSelf = self
        self.userRepository.loginWithUsername(username: loginInfo.username, password: loginInfo.password) { (error, data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if loginInfo.wishesToBeRemembered {
                CredentialsStore.saveCredentials(username: loginInfo.username, password: loginInfo.password)
            }
            
            weakSelf?.afterLoggingInWith(identity: data)
        }
    }
    
    
    private func registerWithInfoAndUpdateUI(_ info: RegistrationInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.userRepository.registerNewUserWith(username: info.username, email: info.email, password: info.password) { error in
            
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
        self.flowController.displayDashboard()
        self.flowController.setSideMenu(enabled: true)
    }
    
    
    private func logoutUserAndUpdateUI(){
        weak var weakSelf = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.userRepository.logoutUserWith { error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            CredentialsStore.deleteCredentials()
            
            self.flowController.setSideMenu(enabled: false)
            self.flowController.displayLoginHierarchyWith(loginCallback: { loginInfo in
                weakSelf?.logiWithInfoAndUpdateUI(loginInfo)
                }, registerCallback: { registerInfo in
                    weakSelf?.registerWithInfoAndUpdateUI(registerInfo)
                    
            })
        }
    }
    
    private func dismiss(notification: OPNotification, andTakeAction action: String){
        
        self.dependencies.notificationsRepository.dismiss(notification: notification) { error in
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
    
}
