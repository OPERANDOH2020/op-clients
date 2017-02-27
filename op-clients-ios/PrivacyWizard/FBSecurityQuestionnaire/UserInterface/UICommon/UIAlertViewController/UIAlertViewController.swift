//
//  UIAlertViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIAlertViewController: NSObject {
    
    // MARK: - Public Static Methods
    class func presentOkAlert(from viewController: UIViewController, title: String, message: String) {
        presentOkAlert(from: viewController, title: title, message: message, submitCallback: nil)
    }
    
    class func presentOkAlert(from viewController: UIViewController, title: String, message: String, submitCallback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: submitCallback))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func presentOkCancelAlert(from viewController: UIViewController, title: String, message: String, submitCallback: ((UIAlertAction) -> Void)?, cancelCallback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelCallback))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: submitCallback))
        viewController.present(alert, animated: true, completion: nil)
    }
}
