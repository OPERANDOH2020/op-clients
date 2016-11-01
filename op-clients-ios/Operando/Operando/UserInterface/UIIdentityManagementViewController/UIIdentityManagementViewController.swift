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
let kNoIdentitiesAtTheMomentLocalizableKey = "kNoIdentitiesAtTheMomentLocalizableKey"

let kMaxNumOfIdentities: Int = 20


class UIIdentityManagementViewController: UIViewController
{
    private var identitiesRepository: IdentitiesManagementRepository?
    private var currentNumOfIdentities: Int = 0 {
        didSet{
            self.updateUIBasedOnNumOfIdentities(self.currentNumOfIdentities)
        }
    }
    
    @IBOutlet weak var identitiesListView: UIIdentitiesListView?
    @IBOutlet weak var addNewIdentityButton: UIButton?
    @IBOutlet weak var realIdentityLabel: UILabel!
    @IBOutlet weak var numOfIdentitiesLeftLabel: UILabel!
    
    @IBOutlet weak var yourRealIdentityLabel: UILabel!

    
    
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
    
    private func updateUIBasedOnNumOfIdentities(_ num: Int){
        self.numOfIdentitiesLeftLabel.text = "You can add \(kMaxNumOfIdentities - num) more identities"
        if num == kMaxNumOfIdentities {
            self.addNewIdentityButton?.isUserInteractionEnabled = false
            self.addNewIdentityButton?.alpha = 0.6
        } else {
            self.addNewIdentityButton?.isUserInteractionEnabled = true
            self.addNewIdentityButton?.alpha = 1.0
        }
    }
    
    private func loadCurrentIdentitiesWith(repository: IdentitiesManagementRepository?)
    {
        repository?.getRealIdentityWith(completion: { realIdentity, _ in
            self.realIdentityLabel.text = realIdentity
        })
        
        repository?.getCurrentIdentitiesListWith(completion: { (identities, error) in
            if let error = error
            {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.currentNumOfIdentities = identities.identitiesList.count
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
                self.currentNumOfIdentities -= 1
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
            
            self.identitiesListView?.displayAsDefault(identity: identity)
            
        })
    }
    
    
    private func addNewIdentity(){
        UIAddIdentityAlertViewController.displayAndAddIdentityWith(identitiesRepository: self.identitiesRepository) { identity in
            self.identitiesListView?.appendAndDisplayNew(item: identity)
            self.currentNumOfIdentities += 1
        }
        
    }
    
}
