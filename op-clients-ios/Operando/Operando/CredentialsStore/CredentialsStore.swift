//
//  CredentialsStore.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

//TO DO: In production, must replace the use of NSUserDefaults with KeyChain
//NSUserDefaults will be used for the purposes of the demo

class CredentialsStore: NSObject
{
    
    static let DefaultsUsernameKey = "DefaultsUsernameKey"
    static let DefaultsPasswordKey = "DefaultsPasswordKey"
    
    class func retrieveLastSavedCredentialsIfAny() -> (username: String, password: String)?
    {
        let defaults = UserDefaults.standard;
        
        if let username = defaults.object(forKey: DefaultsUsernameKey) as? String,
               let password = defaults.object(forKey: DefaultsPasswordKey) as? String
        {
            return (username, password);
        }
        
        return nil;
    }
    
    
    class func saveCredentials(username: String, password: String)
    {
        let defaults = UserDefaults.standard;
        
        defaults.set(username, forKey: DefaultsUsernameKey);
        defaults.set(password, forKey: DefaultsPasswordKey);
        
        defaults.synchronize()
    }
    
    
    class func deleteCredentials() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsUsernameKey)
        defaults.removeObject(forKey: DefaultsPasswordKey)
        defaults.synchronize()
        
    }
    
}
