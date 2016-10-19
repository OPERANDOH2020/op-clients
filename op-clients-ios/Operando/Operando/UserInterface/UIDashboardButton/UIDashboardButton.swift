//
//  UIDashboardButton.swift
//  Operando
//
//  Created by Costin Andronache on 10/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIDashboardButtonModel{
    let backgroundColor: UIColor?
    let title: String?
    let image: UIImage?
    let onTap: VoidBlock?
}

class UIDashboardButton: RSNibDesignableView {

    private var model: UIDashboardButtonModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
    }
    
    
    func setupWith(model: UIDashboardButtonModel?){
        self.model = model
        self.contentView?.backgroundColor = model?.backgroundColor
        self.titleLabel.text = model?.title
        self.imageView.image = model?.image
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.imageView.alpha = 0.6;
        self.titleLabel.alpha = 0.6
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.imageView.alpha = 1.0
        self.titleLabel.alpha = 1.0
        
        DispatchQueue.main.async {
            self.model?.onTap?()
        }
    }
    
}
