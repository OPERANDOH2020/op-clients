//
//  UINotificationCell.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationCell: MGSwipeTableCell {

    static let identifierNibName = "UINotificationCell"
    
    @IBOutlet weak var notificationTextLabel: UILabel!
    
    func setupWith(notification: OPNotification){
        self.notificationTextLabel.text = notification.title
    }
    
}
