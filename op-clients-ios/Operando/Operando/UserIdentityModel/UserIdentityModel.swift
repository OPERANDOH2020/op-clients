//
//  UserIdentityModel.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

class UserIdentityModel
{

    let sessionId: String
    let userId: String
    
    init?(swarmClientLoginReply: [String: Any])
    {
        guard let userId = swarmClientLoginReply["userId"] as? String,
              let sessionId = swarmClientLoginReply["sessionId"] as? String,
              let authenticated = swarmClientLoginReply["authenticated"] as? Bool
            else
        {
                return nil
        }
        
        if !authenticated {return nil}
        
        
        self.userId = userId
        self.sessionId = sessionId
    }
}
