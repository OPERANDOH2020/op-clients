//
//  UIMainFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIMainFlowController: UIFlowController {
    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    private var privacyWizardSetupAttempts = 0
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        if let frame = configuration.window?.bounds {
            navigationController.view.frame = frame
        }
        
        configuration.window?.rootViewController = navigationController
        configuration.window?.makeKeyAndVisible()
        
        let mainScreenVCConfiguration = UIFlowConfiguration(window: nil, navigationController: navigationController, parent: self)
        childFlow = UIMainScreenFlowController(configuration: mainScreenVCConfiguration)
        childFlow?.start()
        
        //ProgressHUD.show("Configuring Privacy Wizard")
        //setupPrivacyWizard()
    }
    
    private func setupPrivacyWizard() {
        privacyWizardSetupAttempts += 1
        print("Privacy Wizard Setup Attempt No.\(privacyWizardSetupAttempts)")
        ACPrivacyWizard.shared.setup { (success) in
            if success {
                ProgressHUD.dismiss()
            } else {
                if self.privacyWizardSetupAttempts < 3 {
                    self.setupPrivacyWizard()
                } else {
                    // TODO: - Show error
                    ProgressHUD.dismiss()
                }
            }
        }
    }
}
