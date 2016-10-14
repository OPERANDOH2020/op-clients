//
//  LoginView.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct LoginInfo
{
    let username : String
    let password: String
    let wishesToBeRemembered: Bool
}

struct UILoginViewCallbacks
{
    let whenUserWantsToLogin : ((_ info : LoginInfo) -> ())?
    let whenUserForgetsPassword: (() -> ())?
}

class UILoginView: RSNibDesignableView {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    private var callbacks: UILoginViewCallbacks?
    
    
    func setupWithCallbacks(callbacks: UILoginViewCallbacks?)
    {
        self.callbacks = callbacks;
    }
    
    @IBAction func didPressForgotPassword(sender: AnyObject)
    {
        self.callbacks?.whenUserForgetsPassword?();
    }
    
    @IBAction func didPressSignInButton(_ sender: AnyObject)
    {
        let loginInfo = LoginInfo(username: self.emailTF.text ?? "", password: self.passwordTF.text ?? "", wishesToBeRemembered: self.rememberMeSwitch.isOn);
        self.callbacks?.whenUserWantsToLogin?(loginInfo);
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    

}
