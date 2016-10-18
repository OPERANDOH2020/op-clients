//
//  UIIdentityCell.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIdentityCell: UITableViewCell {
    
    static let identifierNibName = "UIIdentityCell"
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    @IBOutlet weak var identityLabel: UILabel!
    

    func setupWithIdentity(identity: String?, isDefault: Bool)
    {
        checkmarkImageView.isHidden = !isDefault
        self.identityLabel.text = identity;
    }
    
    
}
