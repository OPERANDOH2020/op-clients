//
//  SCDDocumentCell.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class SCDDocumentCell: UITableViewCell {
    
    static let identifierNibName: String = "SCDDocumentCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var urlListLable: UILabel!
    
    func setup(with scdDocument: SCDDocument){
        self.titleLabel.text = scdDocument.appTitle
        self.bundleLabel.text = scdDocument.bundleId
        self.urlListLable.text = "The app accesses \(scdDocument.accessedLinks.count) urls"
    }
    
    
    
}
