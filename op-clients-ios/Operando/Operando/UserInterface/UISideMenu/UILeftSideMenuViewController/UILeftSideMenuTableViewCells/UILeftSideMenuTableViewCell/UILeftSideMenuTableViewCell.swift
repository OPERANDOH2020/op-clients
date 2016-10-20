//
//  UILeftSideMenuTableViewCell.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let UILeftSideMenuTableViewCellIdentifier = "UILeftSideMenuTableViewCellIdentifier"

struct UILeftSideMenuTVCellObject {
    var categoryImageName: String
    var title: String
}

class UILeftSideMenuTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    func setup(withObject object: UILeftSideMenuTVCellObject) {
        categoryImageView.image = UIImage(named: object.categoryImageName)
        titleLabel.text = object.title
    }
}
