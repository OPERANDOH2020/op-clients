//
//  ViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didTapLoginButton(_ sender: Any) {
        //ACSwarmManager.shared.loginWithUsername(username: "a", password: "aaaa")
    }
    
    @IBAction func didTapStartPartyButton(_ sender: Any) {
        //ACSwarmManager.sharedInstance.getOSPSettings()
    }
    
    @IBAction func didTapRecommendedParamsButton(_ sender: Any) {
        //ACSwarmManager.sharedInstance.getOSPSettingsRecommendedParameters()
    }
    
    @IBAction func didTapConnectWithJSButton(_ sender: Any) {
//        JSPrivacyWizardContext.shared.getNextQuestionAndSuggestions { (data) in
//            print(data)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
