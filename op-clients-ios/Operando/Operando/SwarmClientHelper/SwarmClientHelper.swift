//
//  SwarmClientHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

import SwarmClient
typealias SwarmClientCallback = ((_ error: NSError?, _ data: Any?) -> Void)

class SwarmClientHelper: NSObject
{
    static let ServerURL = "http://192.168.100.144:9001";
    //let swarmClient = SwarmClient(connectionURL: SwarmClientHelper.ServerURL);
    
    var lastOperationCallback: SwarmClientCallback?
    
    override init() {
        super.init()
        //self.swarmClient.delegate = self
    }
    
    
    func loginWithUsername(username: String, password: String, withCompletion completion: SwarmClientCallback?)
    {
        self.lastOperationCallback = completion;
        //swarmClient.startSwarm("login.js", phase: "start", ctor: "userLogin", arguments: [username, password])

    }
    
    //MARK: protocol
    
    func didFailedToCreateSocket(error: NSError)
    {
        lastOperationCallback?(error, nil);
        lastOperationCallback = nil;
    }
    
    
    func didReceiveData(data: [AnyObject])
    {
        lastOperationCallback?(nil, data)
        lastOperationCallback = nil
    }
}
