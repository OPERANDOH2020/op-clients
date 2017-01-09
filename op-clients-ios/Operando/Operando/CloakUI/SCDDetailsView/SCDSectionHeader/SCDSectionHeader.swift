//
//  SCDSectionHeader.swift
//  Operando
//
//  Created by Costin Andronache on 1/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct SCDSectionHeaderCallbacks {
    let callToExpand: ((Void) -> Void)?
    let callToContract: ((Void) -> Void)?
}

class SCDSectionHeader: RSNibDesignableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var expandContractButton: UIButton!
    
    private var callbacks: SCDSectionHeaderCallbacks?
    
    func setupWith(title: String, callbacks: SCDSectionHeaderCallbacks?){
        self.callbacks = callbacks
        self.sectionTitleLabel.text = title
    }
    
    
    @IBAction func didPressButton(_ sender: Any) {
        self.expandContractButton.isSelected = !self.expandContractButton.isSelected
        if self.expandContractButton.isSelected {
            self.callbacks?.callToExpand?()
        } else {
            self.callbacks?.callToContract?()
        }
    }
    
}
