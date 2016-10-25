//
//  UINotificationCell.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationCell: UITableViewCell {

    static let identifierNibName = "UINotificationCell"
    
    @IBOutlet weak var notificationTextLabel: UILabel!
    
    func setupWith(notificationText: String){
        self.notificationTextLabel.text = notificationText
    }
    
}
