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
    
    private var callbacks: UIDashBoardViewControllerCallbacks?
    
    @IBOutlet var identityManagementButton: UIButton?
    @IBOutlet var privacyForBenefitsButton: UIButton?
    @IBOutlet var privateBrowsingButton: UIButton?
    @IBOutlet var notificationsButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localizeButtonTitles()
    }
    
    
    func setupWith(callbacks: UIDashBoardViewControllerCallbacks?)
    {
        self.callbacks = callbacks
    }
    
    private func localizeButtonTitles()
    {
        self.identityManagementButton?.setTitle(Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), for: .normal)
        self.privacyForBenefitsButton?.setTitle(Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), for: .normal)
        self.privateBrowsingButton?.setTitle(Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), for: .normal)
        self.notificationsButton?.setTitle(Bundle.localizedStringFor(key: kNotificationsLocalizableKey), for: .normal)
    }
    
    
    @IBAction func didPressIdentityManagement(_ sender: UIButton)
    {
        self.callbacks?.whenChoosingIdentitiesManagement?()
    }
    
    @IBAction func didPressPrivacyForBenefits(_ sender: UIButton)
    {
        self.callbacks?.whenChoosingPrivacyForBenefits?()
    }
    
    @IBAction func didPressPrivateBrowsing(_ sender: UIButton)
    {
        self.callbacks?.whenChoosingPrivateBrowsing?()
    }
    
    @IBAction func didPressNotifications(_ sender: UIButton)
    {
        self.callbacks?.whenChoosingNotifications?()
    }
}
