//
//  UserInfoRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

struct UserInfo{
    let email: String
    let name: String
    init?(dict: [String: Any]){
        guard let email = dict["email"] as? String,
            let name = dict["userName"] as? String else {
                return nil
        }
        
        self.email = email
        self.name = name
    }
    private init(){
        self.email = ""
        self.name = ""
    }
    
    static let defaultEmpty = UserInfo()
}

typealias UserInfoCallback = (_ userInfo: UserInfo, _ error: NSError?) -> Void


protocol UserInfoRepository {
    func getCurrentUserInfo(in completion: UserInfoCallback?)
    func changeCurrent(password: String, to newPassword: String, withCompletion completion: ((_ error: NSError?) -> Void)?)
}


class DummyInfoRepository: UserInfoRepository {
    func getCurrentUserInfo(in completion: UserInfoCallback?) {
        
        completion?(UserInfo(dict: ["email": "call@me.later", "userName": "Blanos pufos"])!, nil)
    }
    
    func changeCurrent(password: String, to newPassword: String, withCompletion completion: ((NSError?) -> Void)?) {
        completion?(nil)
    }
    
}
