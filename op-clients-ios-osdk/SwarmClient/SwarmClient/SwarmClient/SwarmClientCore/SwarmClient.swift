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
    
    private var onReconnectIfAny: (() -> Void)?
    private var onDisconnect: (() -> Void)?
    private var onErrorWithReason: ((_ reason: String) -> Void)?
    
    open var delegate: SwarmClientProtocol?
    
    // MARK: - Lifecycle
    public init(connectionURL: String) {
        self.connectionURL = connectionURL
        tenantId = ""
        didConnect = false
        emitsArray = []
        super.init()
        
        weak var weakSel = self
        self.onDisconnect = {
            weakSel?.delegate?.socketDidDisconnect()
        }
        
        self.onErrorWithReason = { reason in
            weakSel?.delegate?.didFailOperationWith(reason: reason)
        }
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
            self.onDisconnect?()
        }
        
        socketIO.on(SocketIOEventsNames.error.rawValue) { (data, emitter) in
            let reason = (data.first as? String) ?? "Unknown socket error"
            self.onErrorWithReason?(reason)
            
            
        }
    }
    
    fileprivate func handleSocketCreationEvent()
    {
        self.onReconnectIfAny?()
        
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
    
    public func startSwarm(_ swarmName: String, phase: String, ctor: String, arguments: [AnyObject]) {
        let swarmDictionary = Swarm.getSwarmDictionary(tenantId, swarmName: swarmName, phase: phase, ctor: ctor, arguments: arguments)
        if didConnect {
            emitSwarmMessage(swarmDictionary)
        } else {
            emitsArray.append(swarmDictionary)
            createSocket()
        }
    }
    
    public func disconnectAndReconnectWith(completion: ((_ errorMessage: String?) -> Void)? ) {
        self.didConnect = false
        
        let currentOnDisconnect = self.onDisconnect
        let currentOnFailWithReason = self.onErrorWithReason
        
        weak var weakSelf = self
        
        self.onDisconnect = {
            weakSelf?.socketIO?.connect()
        }

        self.onErrorWithReason = { reason in
            completion?(reason)
        }
        
        self.onReconnectIfAny = {
            completion?(nil)
            weakSelf?.onDisconnect = currentOnDisconnect
            weakSelf?.onErrorWithReason = currentOnFailWithReason
        }
        
        self.socketIO?.disconnect()
    }
    
}
