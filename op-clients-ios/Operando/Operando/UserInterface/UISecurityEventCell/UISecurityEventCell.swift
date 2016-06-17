//
//  UISecurityEventCell.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISecurityEventCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsURLLabel: UILabel!
    
    static let idenitiferNibName = "UISecurityEventCell";
    
    func setupWithSecurityEvent(securityEvent: IPSecurityEvent)
    {
        self.titleLabel.text = securityEvent.title
        self.descriptionLabel.text = securityEvent.description
        self.detailsURLLabel.text = securityEvent.detailsURL
    }
    
    
    @IBAction func didTapOnDetailsURL(sender: AnyObject)
    {
        //ugly, but will do for now 
        guard let urlString = self.detailsURLLabel.text else {return}
        
        guard let url = NSURL(string: urlString) else {return}
        
        guard UIApplication.sharedApplication().canOpenURL(url) else {return}
        
        UIApplication.sharedApplication().openURL(url);
    
    }
    
}
