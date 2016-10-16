//
//  SwarmClientHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//
//
//   WARNING: 
//   If you call a method from within the completion block of another method, you must wrap the second call
//   in a DispatchQueue.whateverQueueYouAreCalling.async{}
// 

import Foundation
import SwarmClient

class SwarmClientHelper: NSObject, SwarmClientProtocol,
                        IdentitiesManagementRepository,
                        PrivacyForBenefitsRepository,
                        UsersRepository,
                        UserInfoRepository
{
    static let ServerURL = "http://192.168.100.86:8080";
    let swarmClient = SwarmClient(connectionURL: SwarmClientHelper.ServerURL);
    
    var whenReceivingData: ((_ data: [Any]) -> Void)?
    var whenThereWasAnError: ((_ error: NSError?) -> Void)?
    
    var whenThereWasAnErrorInCreatingTheSocket: ((_ error: NSError?) -> Void)?
    var whenSockedDidDisconnect: VoidBlock?
    
    override init() {
        super.init()
        self.swarmClient.delegate = self
    }
    
    //MARK: UsersRepository
    
    func loginWithUsername(username: String, password: String, withCompletion completion: UserOperationCallback?)
    {

        self.whenThereWasAnError = { error in
            completion?(error, nil)
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
        
        swarmClient.startSwarm(SwarmName.login.rawValue, phase: SwarmPhase.start.rawValue, ctor: LoginConstructor.userLogin.rawValue, arguments: [username as AnyObject, password as AnyObject])
    }
    
    func registerNewUserWith(username: String, password: String, withCompletion completion: UserOperationCallback?)
    {
        
    }
    
    //MARK: UserInfoRepository
    
    func getCurrentUserInfo(in completion: UserInfoCallback?)
    {
        
    }
    
    func updateCurrentInfoWith(properties: [String: Any], withCompletion completion: UserInfoCallback?)
    {
        
    }
    
    //MARK: IdentitiesManagementRepository
    
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?)
    {
        
        self.whenThereWasAnError = { error in
            completion?(.defaultEmptyResponse, error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(.defaultEmptyResponse, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let identitiesList = SwarmClientResponseParsers.parseIdentitiesList(from: dataDict) else
            {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?(.defaultEmptyResponse, error)
                return
            }
            
            completion?(identitiesList, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.getMyIdentities.rawValue, arguments: [])
    }
    
    func getCurrentListOfDomainsWith(completion: ((_ domainsList: [Domain], _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?([], error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?([], OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let domainsList = SwarmClientResponseParsers.parseDomainsList(from: dataDict) else
            {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?([], error)
                return
            }
            
            completion?(domainsList, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.listDomains.rawValue, arguments: [])
    }
    
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?("", error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?("", OPErrorContainer.errorInvalidServerResponse)
                return
                
            }
            guard let generatedIdentity = SwarmClientResponseParsers.parseGeneratedIdentity(from: dataDict) else
            {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?("", error)
                return
            }
            
            completion?(generatedIdentity, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.generateIdentity.rawValue, arguments: [])
    }
    
    func add(identity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?(false, error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(false, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let successStatus = SwarmClientResponseParsers.parseAddIdentitySuccessStatus(from: dataDict) else{
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?(false, error)
                return
            }
            
            completion?(successStatus, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.createIdentity.rawValue, arguments: [["email": identity] as AnyObject ])
    }
    
    func remove(identity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?(false, error)
        }
        
        self.whenSockedDidDisconnect = {
            completion?(false, OPErrorContainer.errorConnectionLost)
        }
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(false, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let successStatus = SwarmClientResponseParsers.parseDeleteIdentitySuccessStatus(from: dataDict) else {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?(false, error)
                return
            }
            
            completion?(successStatus, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.removeIdentity.rawValue, arguments: [["email": identity] as AnyObject ])
    }
    
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?(false, error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(false, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            
            guard let successStatus = SwarmClientResponseParsers.parseUpdateSubstituteIdentitySuccessStatus(from: dataDict) else {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?(false, error)
                return
            }
            
            completion?(successStatus, nil)
        }
    
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.updateDefaultSubstituteIdentity.rawValue, arguments: [ ["email": newIdentity] as AnyObject ])
    }
    
    //MARK: Privacy for benefits
    
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?([], error)
        }
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?([], OPErrorContainer.errorInvalidServerResponse)
                return
            }
            
            guard let pfbDeals = SwarmClientResponseParsers.parsePfbDeals(from: dataDict) else{
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?([], error)
                return
            }
            
            completion?(pfbDeals, nil)
        }
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.getAllDeals.rawValue, arguments: [])

    }
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        
        self.whenThereWasAnError = { error in
            completion?(false, error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(false, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let successStatus = SwarmClientResponseParsers.parseSubscribeToDealSuccessStatus(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(false, error)
                    return
            }
            
            completion?(successStatus, nil)
        }
        
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.acceptPfbDeal.rawValue, arguments: [ serviceId as AnyObject ] )
    }
    
    
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        self.whenThereWasAnError = { error in
            completion?(false, error)
        }
        
        
        self.whenReceivingData = { dataArray in
            guard let dataDict = dataArray.first as? [String: Any] else {
                completion?(false, OPErrorContainer.errorInvalidServerResponse)
                return
            }
            guard let successStatus = SwarmClientResponseParsers.parseSubscribeToDealSuccessStatus(from: dataDict) else {
                let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                completion?(false, error)
                return
            }
            
            completion?(successStatus, nil)
        }
        
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.acceptPfbDeal.rawValue, arguments: [ serviceId as AnyObject ] )
    }
    

    
    
    //MARK: SwarmClientProtocol
    
    func didFailedToCreateSocket(_ error: NSError){
        self.whenThereWasAnErrorInCreatingTheSocket?(error)
    }
    
    func socketDidDisconnect() {
        print("Socket did disconnect")
        self.whenSockedDidDisconnect?()
    }
    
    func didReceiveData(_ data: [Any]){
        self.whenReceivingData?(data)
        self.removeCallbacksForSwarmCalls()
    }
    
    func didFailOperationWith(reason: String) {
        let error = NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: reason])
        self.whenThereWasAnError?(error)
        self.removeCallbacksForSwarmCalls()
    }
    
    //internal 
    
    private func removeCallbacksForSwarmCalls(){
        self.whenReceivingData = nil
        self.whenThereWasAnError = nil
    }
}
