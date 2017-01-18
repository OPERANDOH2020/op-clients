//
//  SCDDetailsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PlusPrivacyCommonTypes


class SCDDetailsViewController: UIViewController {

    @IBOutlet weak var scdDetailsView: SCDDetailsView!

    private var backCallback: VoidBlock?
    
    func setupWith(scd: SCDDocument, backCallback: VoidBlock?) {
        let _ = self.view
        self.scdDetailsView.setupWith(scd: scd)
        self.backCallback = backCallback
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.backCallback?()
    }

}
