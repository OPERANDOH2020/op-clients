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
    
    
    func displayExternalConnectionInfo(info: ExternalConnectionInfo)
    {
        self.addressLabel.text = info.connectionPair.address ?? "N/A";
        
        self.ipInfoView.displayInfo(info.connectionIPInfo);
    }
    
    static var identifierNibName: String
    {
        return "UIExternalConnectionInfoCell";
    }
    
    static var desiredHeight: CGFloat
    {
        return 170.0;
    }
}
