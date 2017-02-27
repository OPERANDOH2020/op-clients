//
//  UIQuestionnaireTableViewCell.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 04/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

typealias DidTapButtonCallback = (_ cell: UITableViewCell) -> Void

let UIQuestionnaireTableViewCellIdentifier = "UIQuestionnaireTableViewCellIdentifier"

class UIQuestionnaireTableViewCell: UITableViewCell {
    
    private var dataSource: AMAvailableReadSetting? {
        didSet {
            guard let dataSource = dataSource else { return }
            
            titleLabel.text = dataSource.name
            toggleImageView.tintColor = dataSource.isSelected ? .operandoGreen : .lightGray
        }
    }
    
    private var toggleButtonCallback: DidTapButtonCallback?

    // MARK: - @IBOutlets
    @IBOutlet weak var toggleImageView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - @IBActions
    @IBAction func didTapToggleButton(_ sender: Any) {
        toggleButtonCallback?(self)
        toggleImageView.tintColor = .operandoGreen
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleImageView.image = UIImage.emptyMarkImage?.withRenderingMode(.alwaysTemplate)
        toggleImageView.tintColor = .lightGray
        contentView.backgroundColor = .operandoMidBlue
    }
    
    // MARK: - Public Methods
    func setup(withModel model: AMAvailableReadSetting?, selectionCallback callback: DidTapButtonCallback?) {
        dataSource = model
        toggleButtonCallback = callback
    }
}
