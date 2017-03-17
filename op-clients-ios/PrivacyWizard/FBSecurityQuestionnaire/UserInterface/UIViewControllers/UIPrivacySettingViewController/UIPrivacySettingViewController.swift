//
//  UIPrivacySettingViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UIPrivacySettingVCStoryboardId = "UIPrivacySettingVCStoryboardId"

protocol UIPrivacySettingProtocol {
    func launchFacebookPrivacySetting()
    func launchLinkedInPrivacySetting()
}

class UIPrivacySettingViewController: UIViewController {

    // MARK: - Properties
    var delegate: UIPrivacySettingProtocol?
    
    // MARK: - @IBActions
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - @IBActions
    func didTapBackButtonItem() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapFacebookButton(_ sender: Any) {
        delegate?.launchFacebookPrivacySetting()
    }
    
    @IBAction func didTapLinkedInButton(_ sender: Any) {
        delegate?.launchLinkedInPrivacySetting()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.backgroundColor = .operandoDarkBlue
        linkedInButton.backgroundColor = .operandoDarkBlue
        facebookButton.roundedCorners(withRadius: 5.0)
        linkedInButton.roundedCorners(withRadius: 5.0)
        view.add(gradientWithType: .vertical, fromColors: UIColor.operandoSkyGradientColors)
        view.bringSubview(toFront: contentView)
        navigationItem.addCustomBackButton(target: self, selector: #selector(UIPrivacySettingViewController.didTapBackButtonItem))
    }
}
