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
        infoView = DisclaimerView.initWith(title: "Lorem ipsum title", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nNam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", delegate: self)
        childViewController?.view.addSubview(infoView)
        infoView.setNeedsDisplay()
    }
    
    private func presentOptions() {
        guard let childViewController = childViewController else { return }
        UIAlertViewController.presentXLActionController(from: childViewController, headerTitle: "Options", actions: [
            ((title: "Facebook", subtitle: "Set your privacy on Facebook.", image: UIImage(named: "facebook_icon_"), callback: {
                self.openQuestionnnaire(withScope: .facebook)
            })),
            ((title: "LinkedIn", subtitle: "Set your privacy on LinkedIn.", image: UIImage(named: "linkedin_icon_"), callback: {
                self.openQuestionnnaire(withScope: .linkedIn)
            })),
            ((title: "All Social Networks", subtitle: "Set your privacy on multiple social media at once.", image: UIImage(named: "multiple_social_media_"), callback: {
                self.openQuestionnnaire(withScope: .all)
            }))
            ])
    }
    
    private func openQuestionnnaire(withScope scope: ACPrivacyWizardScope) {
        ACPrivacyWizard.shared.selectedScope = scope
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UIQuestionnaireFlowController(configuration: questionnaireTVCConfiguration)
        (childFlow as? UIQuestionnaireFlowController)?.setup(withPrivacyWizardScope: scope)
        childFlow?.start()
    }
    
    func acceptDisclaimer() {
        infoView.removeFromSuperview()
    }
}
