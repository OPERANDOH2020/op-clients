//
//  UIExternalConnectionInfoCell.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIExternalConnectionInfoCell: UITableViewCell
{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ipInfoView: UIIPInfoView!
    @IBOutlet weak var reportedEventsLabel: UILabel!
    
    func displayExternalConnectionInfo(info: ExternalConnectionInfo)
    {
        self.addressLabel.text = info.connectionPair.address ?? "N/A";
        self.ipInfoView.displayInfo(info.connectionIPInfo);
        
        if info.reportedSecurityEvents.count > 0
        {
            self.reportedEventsLabel.text = "Number of reported events: \(info.reportedSecurityEvents.count)"
        }
        else
        {
            self.reportedEventsLabel.text = "No security events information available";
        }
    }
    
    static var identifierNibName: String
    {
        return "UIExternalConnectionInfoCell";
    }
    
    static var desiredHeight: CGFloat
    {
        return 230;
    }
}
