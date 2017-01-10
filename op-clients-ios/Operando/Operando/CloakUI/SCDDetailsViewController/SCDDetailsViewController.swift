//
//  SCDDetailsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class SCDDetailsViewController: UIViewController {

    @IBOutlet weak var scdDetailsView: SCDDetailsView!

    
    
    func setupWith(scd: SCDDocument) {
        let _ = self.view
        self.scdDetailsView.setupWith(scd: scd)
    }

}
