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
let kNoIncompleteFieldsLocalizableKey = "kNoIncompleteFieldsLocalizableKey"



class UIIdentityManagementViewController: UIViewController
{
    
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
    
    @IBAction func didPressToAddNewIdentity(_ sender: AnyObject) {
        self.addNewIdentity()
    }
    
    
    //MARK: helper
    

    private func loadCurrentIdentitiesWith(repository: IdentitiesManagementRepository?)
    {
        repository?.getCurrentIdentitiesListWith(completion: { (identities, error) in
            if let error = error
            {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.identitiesListView?.setupWith(initialList: identities.identitiesList, defaultIdentityIndex: identities.indexOfDefaultIdentity ,andCallbacks: self.callbacksFor(identitiesListView: self.identitiesListView))
        })
    }
    
    
    
    private func callbacksFor(identitiesListView: UIIdentitiesListView?) -> UIIdentitiesListCallbacks{
        weak var weakSelf = self
        
        return UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { item, index in
            weakSelf?.delete(identity: item, atIndex: index)
          }, whenActivatedItemAtIndex: { item, index in
             weakSelf?.setAsDefault(identity: item, atIndex: index)
        })
        
    }
    
    private func delete(identity: String, atIndex index: Int){
        
        OPViewUtils.displayAlertWithMessage(message: Bundle.localizedStringFor(key: kDoYouWantToDeleteSIDLocalizableKey), withTitle: identity, addCancelAction: true) {
            
            self.identitiesRepository?.remove(identity: identity, withCompletion: { success, error  in
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                if !success{
                    OPErrorContainer.displayError(error: OPErrorContainer.unknownError)
                    return
                }
                
                self.identitiesListView?.deleteItemAt(index: index)
            })
        }
    }
    
    private func setAsDefault(identity: String, atIndex index: Int)
    {
        self.identitiesRepository?.updateDefaultIdentity(to: identity, withCompletion: { success, error  in
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if !success {
                OPErrorContainer.displayError(error: OPErrorContainer.unknownError)
                return
            }
            
            self.identitiesListView?.displayAsDefaultItemAt(index: index)
            
        })
    }
    
    
    private func addNewIdentity(){
        UIAddIdentityAlertViewController.displayAndAddIdentityWith(identitiesRepository: self.identitiesRepository) { identity in
            self.identitiesListView?.appendAndDisplayNew(item: identity)
        }
        
    }
    
}
