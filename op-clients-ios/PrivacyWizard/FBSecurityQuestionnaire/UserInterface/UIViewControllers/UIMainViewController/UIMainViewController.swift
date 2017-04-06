//
//  UIMainViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UIMainVCStoryboardId = "UIMainVCStoryboardId"

protocol UIMainScreenVCDelegate {
    func openQuestionnaire()
    func displayInfo()
}

class UIMainViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var delegate: UIMainScreenVCDelegate?

    // MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var setupPrivacyButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet var contentView: UIRadialGradientView!
    
    // MARK: - @IBActions
    @IBAction func didTapSetupPrivacyButton(_ sender: Any) {
        delegate?.openQuestionnaire()
    }
    
    @IBAction func didTapInfoButton(_ sender: Any) {
        delegate?.displayInfo()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        self.navigationController?.navigationBar.barTintColor = .appDarkBlue
        setupPrivacyButton.layer.borderWidth = 1
        setupPrivacyButton.layer.borderColor = UIColor.appYellow.cgColor
        setupPrivacyButton.layer.cornerRadius = 5.0
        setupPrivacyButton.backgroundColor = .appDarkBlue
        contentView.backgroundColor = .appDarkBlue
        separatorLabel.textColor = .appYellow
        contentView.setup(center: logoImageView.center,
                          pulsarConfiguration: UIRadialGradientViewPulsarConfiguration(minRadius: logoImageView.bounds.width,
                                                                                       maxRadius: 2 * logoImageView.bounds.width,
                                                                                       stepsNo: 100))
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        contentView.startPulsar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        contentView.stopPulsar()
    }
    
    // MARK: - Public Methods
    func setup(delegate: UIMainScreenVCDelegate) {
        self.delegate = delegate
    }
}
