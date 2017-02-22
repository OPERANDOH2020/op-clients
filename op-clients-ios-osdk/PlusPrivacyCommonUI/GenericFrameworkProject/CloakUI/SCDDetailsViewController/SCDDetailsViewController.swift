//
//  SCDDetailsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PlusPrivacyCommonTypes

public typealias VoidBlock = () -> Void

class SCDDetailsViewController: UIViewController {

    @IBOutlet weak var scdDetailsView: SCDDetailsView!

    @IBOutlet weak var appTitleLabel: UILabel!
    private var backCallback: VoidBlock?
    
    func setupWith(scd: SCDDocument, backCallback: VoidBlock?) {
        let _ = self.view
        self.scdDetailsView.setupWith(scd: scd)
        self.backCallback = backCallback
        self.appTitleLabel.text = scd.appTitle;
    }
    

    @IBAction func didPressExitButton(_ sender: Any) {
        self.backCallback?()
    }

}
