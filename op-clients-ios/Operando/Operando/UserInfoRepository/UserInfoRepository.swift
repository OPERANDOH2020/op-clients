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
    let phoneNumber: String?
    init?(dataDict: [String: Any]){
        return nil
    }
    private init(){
        self.email = ""
        self.phoneNumber = ""
    }
    static let defaultEmpty = UserInfo()
}

typealias UserInfoCallback = (_ userInfo: UserInfo, _ error: NSError?) -> Void


protocol UserInfoRepository {
    func getCurrentUserInfo(in completion: UserInfoCallback?)
    func updateCurrentInfoWith(properties: [String: Any], withCompletion completion: UserInfoCallback?)
}


