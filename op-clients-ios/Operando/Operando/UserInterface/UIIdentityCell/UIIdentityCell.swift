//
//  UIIdentityCell.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIdentityCell: UITableViewCell {
    
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var identityLabel: UILabel!
    
    private var whenDeletingButtonPressed: VoidBlock?
    private var whenSwitchActivated: VoidBlock?
    
    
    func setupWithIdentity(identity: String?, whenDeletingButtonPressed: VoidBlock?, whenSwitchActivated: VoidBlock?)
    {
        self.whenDeletingButtonPressed = whenDeletingButtonPressed;
        self.whenSwitchActivated = whenSwitchActivated
        self.identityLabel.text = identity;
        self.defaultSwitch.isOn = true
        
        self.defaultSwitch.isOn = whenSwitchActivated == nil
        self.defaultSwitch.isUserInteractionEnabled = !self.defaultSwitch.isOn
    }
    
    
    
    
    @IBAction func switchActivated(_ sender: AnyObject) {
        self.whenSwitchActivated?()
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: AnyObject)
    {
        self.whenDeletingButtonPressed?();
    }
    static let identifierNibName = "UIIdentityCell"
}
