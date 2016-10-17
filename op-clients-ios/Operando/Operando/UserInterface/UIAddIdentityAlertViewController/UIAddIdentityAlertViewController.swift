//
//  UIAddIdentityAlertViewController.swift
//  Operando
//
//  Created by Costin Andronache on 10/17/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit



class UIAddIdentityAlertViewController: UIViewController {

    @IBOutlet weak var addIdentityView: UIAddIdentityView!
    
    var whenViewDidAppear: VoidBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addIdentityView.isHidden = true
        self.addIdentityView.layer.cornerRadius = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addIdentityView.isHidden = false        
        self.addIdentityView.attachPopUpAnimationWithDuration(0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.whenViewDidAppear?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.addIdentityView.endEditing(true)
    }
    
    
    static func displayAndAddIdentityWith(identitiesRepository: IdentitiesManagementRepository?, whenDone: ((_ identity: String) -> Void)?)
    {
        let vc = UINavigationManager.addIdentityController
        let _ = vc.view
        
        weak var weakVC = vc
        
        let callbacks = UIAddIdentityViewCallbacks(whenPressedClose: {
                weakVC?.dismiss(animated: false, completion: nil)
            },
            whenPressedSave: { result  in
                guard let finalIdentity = result.asFinalIdentity else {
                    OPViewUtils.displayAlertWithMessage(message: Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey), withTitle: "", addCancelAction: false, withConfirmation: nil)
                    return
                }
                
                identitiesRepository?.add(identity: finalIdentity, withCompletion: { success, error  in
                    if let error = error {
                        OPErrorContainer.displayError(error: error)
                        return
                    }
                    
                    if !success {
                        OPErrorContainer.displayError(error: OPErrorContainer.unknownError)
                        return
                    }
                    
                    whenDone?(finalIdentity)
                    weakVC?.dismiss(animated: false, completion: nil)
                    
                })
                
                
            }) {
                
                identitiesRepository?.generateNewIdentityWith(completion: { identity, error in
                    if let error = error {
                        OPErrorContainer.displayError(error: error)
                        return
                    }
                    
                    weakVC?.addIdentityView.changeAlias(to: identity)
                })
        }
        
        identitiesRepository?.getCurrentListOfDomainsWith(completion: { domains, error in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            vc.addIdentityView.setupWith(domains: domains, andCallbacks: callbacks)
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
            
        })
        
    }

}
