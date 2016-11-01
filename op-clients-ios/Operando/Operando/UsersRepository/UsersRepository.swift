//
//  UsersRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


typealias UserOperationCallback = (_ error: NSError?, _ identityModel: UserIdentityModel) -> Void
typealias CallbackWithError = (_ error: NSError?) -> Void

protocol UsersRepository {
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?)
    func registerNewUserWith(username: String, email: String, password: String, withCompletion completion: CallbackWithError?)
    func logoutUserWith(completion: CallbackWithError?)
    func resetPasswordFor(email: String, completion: CallbackWithError?)
}

class DummyUsersRepository: UsersRepository{
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?){
        
        let idm = UserIdentityModel(swarmClientLoginReply: ["userId": "1", "sessionId": "0xcebe", "authenticated": true])!
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion?(nil, idm)
        }
        
        
    }
    
    func registerNewUserWith(username: String, email: String, password: String, withCompletion completion: CallbackWithError?){
        
        completion?(nil)
        
    }
    
    
    func logoutUserWith(completion: ((NSError?) -> Void)?) {
        completion?(nil)
    }
    
    func resetPasswordFor(email: String, completion: CallbackWithError?) {
        completion?(nil)
    }
}
