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
let kAddNewIdentityLocalizableKey = "kAddNewIdentityLocalizableKey"




class UIIdentityManagementViewController: UIViewController
{
    
    private var identitiesList : [String] = [];
    private var identitiesRepository: IdentitiesManagementRepository?
    
    @IBOutlet var identitiesListView: UIIdentitiesListView?
    @IBOutlet var addNewIdentityButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewIdentityButton?.setTitle(Bundle.localizedStringFor(key: kAddNewIdentityLocalizableKey), for: .normal)
    }
    
    func setupWith(identitiesRepository: IdentitiesManagementRepository?)
    {
        let _  = self.view
        self.identitiesRepository = identitiesRepository
        self.loadCurrentIdentitiesWith(repository: identitiesRepository)
    }
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewSID(sender: AnyObject)
    {
        let item = "rr0ky5p1c0@operando7.eu";
        self.displayAlertForItem(item: item, withTitle: Bundle.localizedStringFor(key: kNewSIDGeneratedLocalizableKey), addCancelAction: false, withConfirmation: nil);
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
    

    private func loadCurrentIdentitiesWith(repository: IdentitiesManagementRepository?)
    {
        repository?.getCurrentIdentitiesListWith(completion: { (identities, error) in
            if let error = error
            {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.identitiesListView?.setupWith(initialList: identities.identitiesList, andCallbacks: self.callbacksFor(identitiesListView: self.identitiesListView))
        })
    }
    
    
    
    private func callbacksFor(identitiesListView: UIIdentitiesListView?) -> UIIdentitiesListCallbacks
    {
        weak var weakSelf = self
        weak var weakIdentitiesListView = identitiesListView
        
        return UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { item, index in
            weakSelf?.identitiesRepository?.remove(identity: item, withCompletion: { success, error in
                if let error = error
                {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                
                weakIdentitiesListView?.deleteItemAt(index: index)
            })
        })
        
    }
    
}
