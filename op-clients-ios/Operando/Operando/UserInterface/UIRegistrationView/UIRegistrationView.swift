//
//  UIRegistrationView.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIRegistrationView: RSNibDesignableView, UITextFieldDelegate
{
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
 
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordsDontMatchLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        
        self.invalidEmailLabel.isHidden = true;
        self.passwordsDontMatchLabel.isHidden = true;
        
        self.emailTF.delegate = self;
        self.confirmPasswordTF.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIRegistrationView.keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(UIRegistrationView.keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.disableSignupButton();
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self);
    }
    
    func keyboardWillAppear(notification: NSNotification)
    {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0);
    }
    
    func keyboardWillDisappear(notification: NSNotification)
    {
        self.scrollView.contentInset = UIEdgeInsets.zero;
    }
    
    @IBAction func didPressSignUp(sender: AnyObject)
    {
        
    }
    
    @IBAction func didSwitchShowPasswordsOnOrOff(sender: UISwitch)
    {
        self.setSecureTextEntry(entry: !sender.isOn);
    }
    
    
    //MARK: textfield delegate
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.emailTF
        {
            self.handleEmailDidEndEditing();
        }
        
        if textField == self.confirmPasswordTF
        {
            self.handleConfirmationTFDidEndEditing();
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true);
        return true;
    }
    
    
    //MARK: internal utils
    private func handleEmailDidEndEditing()
    {
        if self.isEmailValid() == false
        {
            self.invalidEmailLabel.isHidden = false;
        }
        else
        {
            self.invalidEmailLabel.isHidden = true;
            
            if self.doPasswordsMatch()
            {
                self.enableSignupButton();
            }
            else
            {
                self.disableSignupButton();
            }
        }
    }
    
    private func handleConfirmationTFDidEndEditing()
    {
        if self.doPasswordsMatch() == false
        {
            self.passwordsDontMatchLabel.isHidden = false;
            self.disableSignupButton();
        }
        else
        {
            self.passwordsDontMatchLabel.isHidden = true;
            if self.isEmailValid()
            {
                self.enableSignupButton();
            }
            else
            {
                self.disableSignupButton()
            }
        }
    }
    
    private func isEmailValid() -> Bool
    {
        guard let email = self.emailTF.text else {return false}
        return OPUtils.isValidEmail(testStr: email);
    }
    
    private func doPasswordsMatch() -> Bool
    {
        guard let password = self.passwordTF.text else {return false}
        guard let confirmation = self.confirmPasswordTF.text else {return false}
        guard password.characters.count > 0 else {return false}
        
        
        return password == confirmation;
    }
    
    private func disableSignupButton()
    {
        self.signUpBtn.isUserInteractionEnabled = false;
        self.signUpBtn.alpha = 0.6;
    }
    
    private func enableSignupButton()
    {
        self.signUpBtn.isUserInteractionEnabled = true;
        self.signUpBtn.alpha = 1.0;
    }
    
    private func setSecureTextEntry(entry: Bool)
    {
        
        self.confirmPasswordTF.isSecureTextEntry = entry;
        self.passwordTF.isSecureTextEntry = entry;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    
}
