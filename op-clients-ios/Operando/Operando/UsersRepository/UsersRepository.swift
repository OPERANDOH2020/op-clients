//
//  UsersRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


typealias UserOperationCallback = (_ error: NSError?, _ identityModel: UserIdentityModel?) -> Void

protocol UsersRepository {
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?)
    func registerNewUserWith(username: String, password: String, withCompletion completion: UserOperationCallback?)
}

class DummyUsersRepository: UsersRepository{
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?){
        
        let idm = UserIdentityModel(swarmClientLoginReply: ["userId": "1", "sessionId": "0xcebe", "authenticated": true])!
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            completion?(nil, idm)
        }
        
        
    }
    
    func registerNewUserWith(username: String, password: String, withCompletion completion: UserOperationCallback?){
        
    }
}
