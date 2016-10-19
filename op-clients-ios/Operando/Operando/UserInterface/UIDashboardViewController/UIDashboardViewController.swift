//
//  UIDashboardViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIDashBoardViewControllerCallbacks
{
    let whenChoosingIdentitiesManagement: VoidBlock?
    let whenChoosingPrivacyForBenefits: VoidBlock?
    let whenChoosingPrivateBrowsing: VoidBlock?
    let whenChoosingNotifications: VoidBlock?
    
}

let kIdentitiesManagementLocalizableKey = "kIdentitiesManagementLocalizableKey"
let kPrivacyForBenefitsLocalizableKey = "kPrivacyForBenefitsLocalizableKey"
let kPrivateBrowsingLocalizableKey = "kPrivateBrowsingLocalizableKey"
let kNotificationsLocalizableKey = "kNotificationsLocalizableKey"

class UIDashboardViewController: UIViewController
{
    
    @IBOutlet var identityManagementButton: UIDashboardButton?
    @IBOutlet var privacyForBenefitsButton: UIDashboardButton?
    @IBOutlet var privateBrowsingButton: UIDashboardButton?
    @IBOutlet var notificationsButton: UIDashboardButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupWith(callbacks: UIDashBoardViewControllerCallbacks?)
    {
        let _ = self.view
    
        self.identityManagementButton?.setupWith(model: UIDashboardButtonModel(backgroundColor: UIColor.operandoDarkGreen, title: Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), image: UIImage(named: "identitiesIcon"), onTap: callbacks?.whenChoosingIdentitiesManagement))
        
        self.privacyForBenefitsButton?.setupWith(model: UIDashboardButtonModel(backgroundColor: UIColor.operandoRed, title: Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), image: UIImage(named: "dealsIcon"), onTap: callbacks?.whenChoosingPrivacyForBenefits))
        
        self.privateBrowsingButton?.setupWith(model: UIDashboardButtonModel(backgroundColor: UIColor.operandoOrange, title: Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), image: UIImage(named: "browsingIcon"), onTap: callbacks?.whenChoosingPrivateBrowsing))
        
        
        self.notificationsButton?.setupWith(model: UIDashboardButtonModel(backgroundColor: UIColor.operandoLightGreen, title: Bundle.localizedStringFor(key: kNotificationsLocalizableKey), image: UIImage(named: "notificationsIcon"), onTap: callbacks?.whenChoosingNotifications))
        
    }
    
    

}
