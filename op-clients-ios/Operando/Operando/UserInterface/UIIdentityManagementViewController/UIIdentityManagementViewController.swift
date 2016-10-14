//
//  UIIdentityManagementViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


let kNewSIDGeneratedLocalizableKey = "kNewSIDGeneratedLocalizableKey"
let kDoYouWantToDeleteSIDLocalizableKey = "kDoYouWantToDeleteSIDLocalizableKey"

class UIIdentityManagementViewController: UIViewController
{
    
    private var identitiesList : [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.identitiesList = self.dummyIdentities();
        
    }
    
    
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewSID(sender: AnyObject)
    {
        let item = "rr0ky5p1c0@operando7.eu";
        self.displayAlertForItem(item: item, withTitle: "New SID generated", addCancelAction: false, withConfirmation: nil);
    }
    
    
    //MARK: tableView delegate / datasource
    
    
    
    
    
    //MARK: helper
    
    
    private func displayAlertForItem(item: String, withTitle title: String, addCancelAction:Bool, withConfirmation confirmation: (() -> ())?)
    {
        let alert = UIAlertController(title: title, message: item, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            confirmation?();
        }
        alert.addAction(okAction);
        
        if addCancelAction
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(cancelAction);
        }
        
        self.present(alert, animated: true, completion: nil);
    }
    

    
    private func dummyIdentities() -> [String]
    {
        return ["g67ash@operando.eu",
                "jd8skg@operando.eu",
                "9dsfdsg8@operando.eu"];
    }
}
