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
let kConnecting = "Connecting"

enum NotificationAction: String {
    case identitiesMangament = "identity"
    case privacyForBenefits = "privacy-for-benefits"
    case privateBrowsing = "privateBrowsing"
}

class OPConfigObject: NSObject
{
    static let sharedInstance = OPConfigObject()
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private var userRepository: UsersRepository?
    private var notificationsRepository: NotificationsRepository?
    private var flowController: UIFlowController?
    private var dependencies: Dependencies?
    private var actionsPerNotificationType: [String: VoidBlock] = [:]
    private var opCloak: OPCloak?

    private func initPropertiesOnAppStart() {
        
        self.userRepository = self.swarmClientHelper
        self.notificationsRepository = self.swarmClientHelper
        weak var weakSelf = self
        
        let plistRepositoryPath = OPConfigObject.pathForFile(named: "SCDRepository")
        let localSchemaPath = Bundle.main.path(forResource: "SCDSchema", ofType: "json") ?? ""
        let scdRepository = PlistSCDRepository(plistFilePath: plistRepositoryPath)
        self.opCloak = OPCloak(schemaProvider: LocalFileSchemaProvider(pathToFile: localSchemaPath),
                               schemaValidator: SwiftSchemaValidator(),
                               scdRepository: scdRepository)
        
        let dependencies = Dependencies(identityManagementRepo:  self.swarmClientHelper,
                                         privacyForBenefitsRepo:  self.swarmClientHelper,
                                         userInfoRepo:            self.swarmClientHelper,
                                         notificationsRepository: self.notificationsRepository,
                                         scdDocumentsRepository: scdRepository,
                                         accountCallbacks: self.createAccountCallbacks(),
            whenTakingActionForNotification: { weakSelf?.dismiss(notification: $1, andTakeAction: $0) },
            whenRequestingNumOfNotifications: { callback in
                weakSelf?.notificationsRepository?.getAllNotifications(in: { notifications, error in
                    if let error = error {
                        OPErrorContainer.displayError(error: error)
                        callback?(0)
                        return
                    }
                    callback?(notifications.count)
                })
            }
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
        self.eraseCredentialsIfFreshAppReinstall()
        
        self.flowController?.setupBaseHierarchyInWindow(window)
        
        flowController?.setSideMenu(enabled: false)
        weak var weakSelf = self
        if let (email, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            ProgressHUD.show(kConnecting)
            self.userRepository?.loginWith(email: email, password: password, withCompletion: { (error, data) in
                ProgressHUD.dismiss()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    weakSelf?.flowController?.displayLoginHierarchy()
                    return
                }
                weakSelf?.currentUserIdentity = data
                weakSelf?.flowController?.setupHierarchyStartingWithDashboardIn(window)
                weakSelf?.flowController?.setSideMenu(enabled: true)
            })
        }
        else {
            weakSelf?.flowController?.displayLoginHierarchy()
            
        }
    }
    
    func open(url: URL) -> Bool {
        if self.opCloak?.canProcess(url: url) ?? false {
            self.opCloak?.processIncoming(url: url)
        }
        return false
    }
    
    
    private func eraseCredentialsIfFreshAppReinstall() {
        let key = "DoNotEraseCredentials"
        if !UserDefaults.standard.bool(forKey: key) {
            CredentialsStore.deleteCredentials()
        }
        
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func logiWithInfoAndUpdateUI(_ loginInfo: LoginInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weak var weakSelf = self
        
        ProgressHUD.show("Connecting")
        self.userRepository?.loginWith(email: loginInfo.email, password: loginInfo.password) { (error, data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            ProgressHUD.dismiss()
            
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if loginInfo.wishesToBeRemembered {
                if let error = CredentialsStore.saveCredentials(username: loginInfo.email, password: loginInfo.password){
                    OPErrorContainer.displayError(error: error)
                }
            }
            
            weakSelf?.afterLoggingInWith(identity: data)
        }
    }
    
    
    private func registerWithInfoAndUpdateUI(_ info: RegistrationInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ProgressHUD.show(kConnecting)
        self.userRepository?.registerNewUserWith(email: info.email, password: info.password) { error in
            ProgressHUD.dismiss()
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
        
        self.dependencies?.notificationsRepository?.dismiss(notification: notification) { error in
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
        ProgressHUD.show(kConnecting)
        self.userRepository?.resetPasswordFor(email: email) { error in
            ProgressHUD.dismiss()
            
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
            
            ProgressHUD.show(kConnecting)
            weakSelf?.userRepository?.changeCurrent(password: oldPassword, to: newPassword, withCompletion: { error in
                ProgressHUD.dismiss()
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
    

    
    private static func pathForFile(named: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        if let documentsDirectory = paths.first{
            var plistPathNSString = documentsDirectory as NSString
            plistPathNSString = plistPathNSString.appendingPathComponent(named) as NSString;
            return plistPathNSString as String;
        }
        return named
    }
}
