//
//  UICustomTableViewHeader.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UICustomTableViewHeaderReuseIdentifier = "UICustomTableViewHeaderReuseIdentifier"

class UICustomTableViewHeader: UITableViewHeaderFooterView {
    
    func setup(withTitle title: String, imageNamed imageName: String?) {
        titleLabel.text = title
        logoImageView.image = UIImage(named: imageName ?? "")
    }
    
    // MARK: - Properties
    var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var borderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // MARK: - Init Methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .operandoMidBlue
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        borderView.backgroundColor = .white
        borderView.autoresizingMask = .flexibleWidth
        contentView.addSubview(titleLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(borderView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 40.0, y: 0.0, width: contentView.frame.width - 55, height: contentView.frame.height)
        titleLabel.numberOfLines = 0
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
        borderView.frame = CGRect(x: 0.0, y: contentView.frame.height - 0.5, width: contentView.frame.width, height: 0.5)
        logoImageView.frame = CGRect(x: 7.5, y: contentView.frame.height/2 - 12.5, width: 25, height: 25)
    }
}
