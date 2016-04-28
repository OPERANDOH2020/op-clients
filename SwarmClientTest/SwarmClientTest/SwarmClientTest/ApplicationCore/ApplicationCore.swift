//
//  ApplicationCore.swift
//  SwarmClientTest
//
//  Created by Catalin Pomirleanu on 4/29/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import SwarmClient

let ACDidReceiveDataFromServerNotification = "ACDidReceiveDataFromServerNotification"
let ACFailedToCreateSocketNotification = "ACFailedToCreateSocketNotification"

class ApplicationCore: NSObject, SwarmClientProtocol {
    
    // MARK: - Properties
    private let swarmClient: SwarmClient
    
    // MARK: - Public Methods
    func login(username: String, password: String) {
        swarmClient.startSwarm("login.js", phase: "start", ctor: "userLogin", arguments: [username, password])
    }
    
    // MARK: - Shared Instance
    class var sharedInstance: ApplicationCore {
        struct Singleton {
            static let instance = ApplicationCore()
        }
        return Singleton.instance
    }
    
    private override init() {
        swarmClient = SwarmClient(connectionURL: WSServerPath)
        super.init()
        swarmClient.delegate = self
    }
    
    // MARK: - Swarm Client Protocol Methods
    func didFailedToCreateSocket(error: NSError) {
        NSNotificationCenter.defaultCenter().postNotificationName(ACFailedToCreateSocketNotification, object: nil)
    }
    
    func didReceiveData(data: [AnyObject]) {
        NSNotificationCenter.defaultCenter().postNotificationName(ACDidReceiveDataFromServerNotification, object: data)
    }
}
