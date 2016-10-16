//
//  OPAlertUtils.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

class OPViewUtils
{
    class func disableViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 0.6;
            view.isUserInteractionEnabled = false;
        }
    }
    
    class func enbleViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 1.0;
            view.isUserInteractionEnabled = true;
        }
    }
    
    class func showOkAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok");
        alert.show();
    }
    
    
    class func displayAlertWithMessage(message: String, withTitle title: String, addCancelAction:Bool, withConfirmation confirmation: (() -> ())?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            confirmation?();
        }
        alert.addAction(okAction);
        
        if addCancelAction
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(cancelAction);
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
    }
}
