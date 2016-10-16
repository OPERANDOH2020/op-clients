/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Cătălin Pomîrleanu (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

import UIKit

enum SocketIOEventsNames: String {
    case message = "message"
    case connect = "connect"
    case disconnect = "disconnect"
    case error = "error"
}

open class SwarmClient: NSObject {
    
    // MARK: - Properties
    fileprivate var socketIO: SocketIOClient?
    fileprivate var tenantId: String
    fileprivate var connectionURL: String
    fileprivate var didConnect: Bool
    fileprivate var emitsArray: [NSDictionary]
    
    open var delegate: SwarmClientProtocol?
    
    // MARK: - Lifecycle
    public init(connectionURL: String) {
        self.connectionURL = connectionURL
        tenantId = ""
        didConnect = false
        emitsArray = []
    }
    
    // MARK: - Private Methods
    fileprivate func setupListeners(_ socketIO: SocketIOClient) {
        socketIO.on(SocketIOEventsNames.message.rawValue) { (receivedData, emitterSocket) in
            self.delegate?.didReceiveData(receivedData)
        }
        
        socketIO.on(SocketIOEventsNames.connect.rawValue) { (receivedData, emitterSocket) in
            self.handleSocketCreationEvent()
        }
        
        socketIO.on(SocketIOEventsNames.disconnect.rawValue) { (data, emitterSocket) in
            self.delegate?.socketDidDisconnect()
        }
        
        socketIO.on(SocketIOEventsNames.error.rawValue) { (data, emitter) in
            let reason = (data.first as? String) ?? "Unknown socket error"
            self.delegate?.didFailOperationWith(reason: reason)
            
        }
    }
    
    fileprivate func handleSocketCreationEvent() {
        didConnect = true
        for swarmDictionary in self.emitsArray {
            emitSwarmMessage(swarmDictionary)
        }
    }
    
    fileprivate func createSocket() {
        didConnect = false
        if let url = URL(string: connectionURL) {
            initSocket(url)
        } else {
            delegate?.didFailedToCreateSocket(SwarmClientErrorGenerator.getInvalidURLError())
        }
    }
    
    fileprivate func initSocket(_ url: URL) {
        socketIO = SocketIOClient(socketURL: url)
        setupListeners(socketIO!)
        socketIO!.connect()
    }
    
    fileprivate func emitSwarmMessage(_ swarmDictionary: NSDictionary) {
        socketIO?.emit(SocketIOEventsNames.message.rawValue, swarmDictionary)
    }
    
    // MARK: - Public Methods
    open func startSwarm(_ swarmName: String, phase: String, ctor: String, arguments: [AnyObject]) {
        let swarmDictionary = Swarm.getSwarmDictionary(tenantId, swarmName: swarmName, phase: phase, ctor: ctor, arguments: arguments)
        if didConnect {
            emitSwarmMessage(swarmDictionary)
        } else {
            emitsArray.append(swarmDictionary)
            createSocket()
        }
    }
}
