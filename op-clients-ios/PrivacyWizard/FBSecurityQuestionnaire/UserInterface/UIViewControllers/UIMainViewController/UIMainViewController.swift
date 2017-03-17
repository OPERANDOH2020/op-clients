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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: - @IBActions
    @IBAction func didTapSetupPrivacyButton(_ sender: Any) {
        delegate?.openQuestionnaire()
    }
    
    @IBAction func didTapInfoButton(_ sender: Any) {
        delegate?.displayInfo()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        self.navigationController?.navigationBar.barTintColor = .operandoSkyBlue
        setupPrivacyButton.backgroundColor = .operandoDarkBlue
        backgroundImageView.image = nil
        setupPrivacyButton.roundedCorners(withRadius: 5.0)
        view.add(gradientWithType: .vertical, fromColors: UIColor.operandoSkyGradientColors)
        bringControlsToFront()
    }
    
    private func bringControlsToFront() {
        view.bringSubview(toFront: titleLabel)
        view.bringSubview(toFront: detailLabel)
        view.bringSubview(toFront: setupPrivacyButton)
        view.bringSubview(toFront: logoImageView)
        view.bringSubview(toFront: infoButton)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Public Methods
    func setup(delegate: UIMainScreenVCDelegate) {
        self.delegate = delegate
    }
}
