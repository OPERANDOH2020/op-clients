//
//  UIPfbDealTableViewCell.swift
//  Operando
//
//  Created by Costin Andronache on 10/18/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIPfbDealTableViewCell: UITableViewCell, UIPfbDisplayingView {
    
    @IBOutlet weak var websiteURL: UILabel!
    @IBOutlet weak var subscriebdSwitch: UISwitch!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    static let identifierNibName = "UIPfbDealTableViewCell"
   
    private var model: PfbDeal?
    private var callbacks: UIPfbDisplayingViewCallbacks?
    
    func setupWith(model: PfbDeal, andCallbacks cbs: UIPfbDisplayingViewCallbacks?){
        self.model = model
        self.callbacks = cbs
        self.websiteURL.text = model.website
        if let url = model.logo, let actualURL  = URL(string: url){
            self.logoImageView.setImageWith(actualURL)
        }
        
        self.subscriebdSwitch.isOn = model.subscribed
    }
    
    func refreshWithOwnModel() {
        self.subscriebdSwitch.isOn = self.model?.subscribed ?? false
    }
    
    @IBAction func switchDidChangeValue(_ sender: UISwitch)
    {
        guard let model = self.model else {
            return
        }
        self.callbacks?.whenUserChangedSubscribedStatusFor?(model, self)
    }
}
