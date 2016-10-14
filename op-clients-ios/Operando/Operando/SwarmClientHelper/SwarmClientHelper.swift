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
typealias SwarmClientLoginCallback = (_ error: NSError?, _ identityModel: UserIdentityModel?) -> Void

class SwarmClientHelper: NSObject, SwarmClientProtocol
{
    static let ServerURL = "http://192.168.100.144:9001";
    let swarmClient = SwarmClient(connectionURL: SwarmClientHelper.ServerURL);
    
    var whenReceivingData: ((_ data: [Any]) -> Void)?
    var whenThereWasAnError: ((_ error: NSError?) -> Void)?
    var whenSockedDidDisconnect: VoidBlock?
    
    override init() {
        super.init()
        self.swarmClient.delegate = self
    }
    
    
    func loginWithUsername(username: String, password: String, withCompletion completion: SwarmClientLoginCallback?)
    {

        self.whenThereWasAnError = { error in
            completion?(error, nil)
        }
        
        self.whenSockedDidDisconnect = {
            completion?(OPErrorContainer.errorInvalidInput, nil)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dict = dataArray.first as? [String: Any],
                  let identityModel = UserIdentityModel(swarmClientLoginReply: dict)
            else
            {
                completion?(OPErrorContainer.errorInvalidServerResponse, nil)
                return
            }
            
            completion?(nil, identityModel)
            
        }
        
        swarmClient.startSwarm("login.js", phase: "start", ctor: "userLogin", arguments: [username as AnyObject, password as AnyObject])
    }
    
    //MARK: protocol
    
    func didFailedToCreateSocket(_ error: NSError)
    {
        self.whenThereWasAnError?(error)
        self.removeAllCallbacks()
    }
    
    
    func didReceiveData(_ data: [Any])
    {
        self.whenReceivingData?(data)
        self.removeAllCallbacks()
    }
    
    func socketDidDisconnect() {
        self.whenSockedDidDisconnect?()
        self.removeAllCallbacks()
    }
    
    
    //internal 
    
    private func removeAllCallbacks()
    {
        self.whenSockedDidDisconnect = nil
        self.whenReceivingData = nil
        self.whenThereWasAnError = nil
    }
}
