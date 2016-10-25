//
//  UIAccountViewController.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kChangePasswordViewHeight: CGFloat = 300

class UIAccountViewController: UIViewController {
    @IBOutlet weak var changePasswordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var changePasswordView: UIChangePasswordView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePasswordViewShowButton()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidePasswordViewShowButton()
    }
    
    @IBAction func didPressChangePasswordButton(_ sender: AnyObject) {
        self.displayPasswordViewHideButton()

    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    private func hidePasswordViewShowButton() {
        self.changePasswordViewHeightConstraint.constant = 0
        self.animateLayoutWith { 
            self.changePasswordButton.alpha = 1.0
        }
    }
    
    private func displayPasswordViewHideButton(){
        self.changePasswordViewHeightConstraint.constant = kChangePasswordViewHeight
        self.animateLayoutWith(extra: {
            self.changePasswordButton.alpha = 0.0
        })
    }
    
    private func animateLayoutWith(extra: VoidBlock?){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            extra?()
            }, completion: nil)
    }

}
