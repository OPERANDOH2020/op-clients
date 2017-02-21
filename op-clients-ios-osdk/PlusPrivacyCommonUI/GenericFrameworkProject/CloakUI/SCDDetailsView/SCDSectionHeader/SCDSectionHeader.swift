//
//  SCDSectionHeader.swift
//  Operando
//
//  Created by Costin Andronache on 1/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

@objc
public class SCDSectionHeaderCallbacks: NSObject {
    
    let callToExpand: ((Void) -> Void)?
    let callToContract: ((Void) -> Void)?
    
    public init(callToExpand: ((Void) -> Void)?, callToContract: ((Void) -> Void)?){
        self.callToExpand = callToExpand
        self.callToContract = callToContract
        super.init()
    }
    
}

@objc
public class SCDSectionHeader: PPNibDesignableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var expandContractButton: UIButton!
    
    static let identifierNibName = "SCDSectionHeader"
    private var callbacks: SCDSectionHeaderCallbacks?
    
    public func setupWith(title: String, callbacks: SCDSectionHeaderCallbacks?){
        self.callbacks = callbacks
        self.sectionTitleLabel.text = title
    }
    
    
    @IBAction func didPressButton(_ sender: Any) {
        
        let shouldExpand = !self.expandContractButton.isSelected

        if shouldExpand {
           self.callbacks?.callToExpand?()
           self.expandContractButton.isSelected = true
        } else {
            self.callbacks?.callToContract?()
            self.expandContractButton.isSelected = false
        }
    }
}
