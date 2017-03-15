//
//  UIMainScreenFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIMainScreenFlowController: UIFlowController, UIMainScreenVCDelegate, DisclaimerViewDelegate {
    
    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    private var childViewController: UIMainViewController?
    private lazy var infoView = DisclaimerView.initView()
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        childViewController = UINavigationManager.getMainScreenViewController()
        childViewController!.setup(delegate: self)
        configuration.navigationController?.pushViewController(childViewController!, animated: true)
    }
    
    // Mark: - Main Screen VC Delegate Methods
    func openQuestionnaire() {
        presentOptions()
    }
    
    func displayInfo() {
        infoView = DisclaimerView.initWith(title: "Lorem ipsum title", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", delegate: self)
        childViewController?.view.addSubview(infoView)
    }
    
    private func presentOptions() {
        guard let childViewController = childViewController else { return }
        UIAlertViewController.presentOptionsAlert(from: childViewController, title: "Configuration options", message: "Select the social media network for setting your privacy.", actions: [
            (title: "Facebook", callback: { (action) in
                self.openQuestionnnaire(withScope: .facebook)
            }),
            (title: "LinkedIn", callback: { (action) in
                self.openQuestionnnaire(withScope: .linkedIn)
            }),
            (title: "All Social Networks", callback: { (action) in
                self.openQuestionnnaire(withScope: .all)
            }),
            (title: "Cancel", callback: nil)
            ])
    }
    
    private func openQuestionnnaire(withScope scope: ACPrivacyWizardScope) {
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UIQuestionnaireFlowController(configuration: questionnaireTVCConfiguration)
        (childFlow as? UIQuestionnaireFlowController)?.setup(withPrivacyWizardScope: scope)
        childFlow?.start()
    }
    
    func acceptDisclaimer() {
        infoView.removeFromSuperview()
    }
}
