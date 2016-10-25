//
//  UIChangePasswordView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIChangePasswordViewCallbacks{
    let whenConfirmedToChange: ((_ currentPassword: String,
    _ newPassword: String) -> Void)?
    
    let whenCanceled: VoidBlock?
}


let kPasswordsMustMatchLocalizableKey = "kPasswordsMustMatchLocalizableKey"

class UIChangePasswordView: RSNibDesignableView {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    private var callbacks: UIChangePasswordViewCallbacks?
    
    func setupWith(callbacks: UIChangePasswordViewCallbacks?){
        self.callbacks = callbacks
    }
    
    
    
    //Mark: IBActions
    
    
    @IBAction func didPressCancel(_ sender: AnyObject) {
        
    }
    
    @IBAction func didPressChange(_ sender: AnyObject) {
        
        
    }
    
    //MARK: Keyboard management
    
    func keyboardWillAppear(_ notification: NSNotification){
        
    }
    
    func keyboardWillDisappear(_ notification: NSNotification){
        
    }
    
    //MARK: private utilities 
    
    private func errorMessageForValidatingPasswords() -> String? {
        guard let newPassword = self.newPasswordTF.text,
            let confirmation = self.confirmPasswordTF.text else {
             return Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey)
        }
        
        return nil 
        
    }
    
}
