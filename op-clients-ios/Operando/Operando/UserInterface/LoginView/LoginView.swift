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
    let email : String
    let password: String
    let wishesToBeRemembered: Bool
}

class UILoginView: RSNibDesignableView {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    
    var whenUserWantsToLogin : ((info : LoginInfo) -> ())?
    var whenUserForgetsPassword: (() -> ())?
    
    @IBAction func didPressForgotPassword(sender: AnyObject)
    {
        self.whenUserForgetsPassword?();
    }
    
    
    @IBAction func didPressSignInButton(sender: AnyObject)
    {
        let loginInfo = LoginInfo(email: self.emailTF.text ?? "", password: self.passwordTF.text ?? "", wishesToBeRemembered: self.rememberMeSwitch.on);
        
        self.whenUserWantsToLogin?(info: loginInfo);
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event);
        self.endEditing(true);
    }
}
