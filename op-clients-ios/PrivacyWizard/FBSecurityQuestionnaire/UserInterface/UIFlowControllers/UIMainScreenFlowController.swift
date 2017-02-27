//
//  UIMainScreenFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

protocol UIMainScreenVCDelegate {
    func openQuestionnaire()
}

class UIMainScreenFlowController: UIFlowController, UIMainScreenVCDelegate {
    
    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        let mainScreenVC = UINavigationManager.getMainScreenViewController()
        mainScreenVC.setup(delegate: self)
        configuration.navigationController?.pushViewController(mainScreenVC, animated: true)
    }
    
    // Mark: - Main Screen VC Delegate Methods
    func openQuestionnaire() {
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UIQuestionnaireFlowController(configuration: questionnaireTVCConfiguration)
        childFlow?.start()
    }
}
