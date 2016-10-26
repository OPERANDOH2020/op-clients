//
//  UsersRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


typealias UserOperationCallback = (_ error: NSError?, _ identityModel: UserIdentityModel) -> Void

protocol UsersRepository {
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?)
    func registerNewUserWith(username: String, email: String, password: String, withCompletion completion: UserOperationCallback?)
    func logoutUserWith(completion: ((_ error: NSError?) -> Void)?)

}

class DummyUsersRepository: UsersRepository{
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?){
        
        let idm = UserIdentityModel(swarmClientLoginReply: ["userId": "1", "sessionId": "0xcebe", "authenticated": true])!
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion?(nil, idm)
        }
        
        
    }
    
    func registerNewUserWith(username: String, email: String, password: String, withCompletion completion: UserOperationCallback?){
        
        completion?(nil, UserIdentityModel(swarmClientLoginReply: ["userId": "1", "sessionId": "1234", "authenticated": true])!)
        
    }
    
    
    func logoutUserWith(completion: ((NSError?) -> Void)?) {
        completion?(nil)
    }
    
}
