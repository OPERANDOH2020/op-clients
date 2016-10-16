//
//  SwarmClientResponseParsers.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


struct IdentitiesListResponse {
    let identitiesList: [String]
    let indexOfDefaultIdentity: Int
    
    static let defaultEmptyResponse = IdentitiesListResponse(identitiesList: [], indexOfDefaultIdentity: -1)
}


struct Domain
{
    let id: String
    let name: String
    
    static let defaultEmpty = Domain(id: "", name: "")
}



struct PfbDeal
{
    let serviceId: Int
    let benefit: String?
    let identitifer: String?
    let description: String?
    let logo: String?
    let voucher: String?
    let website: String?
    var subscribed: Bool
    
    
    init?(dict: [String: Any])
    {
        guard let serviceId = dict["serviceId"] as? Int,
              let subscribed = dict["subscribed"] as? Bool else {
            return nil
        }
        self.serviceId = serviceId
        self.subscribed = subscribed
        
        self.benefit = dict["benefit"] as? String
        self.description = dict["description"] as? String
        self.logo = dict["logo"] as? String
        self.voucher = dict["voucher"] as? String
        self.website = dict["website"] as? String
        self.identitifer = dict["identifier"] as? String
        
    }
}



class SwarmClientResponseParsers
{
    
    
    static func parseErrorIfAny(from dataDict: [String: Any]) -> NSError?
    {
        guard let errorDict = dataDict["error"] as? [String: Any],
              let messageType = errorDict["message"] as? String else
        {
            return nil
        }
        
        if let errorCode = localizableCodesPerErrorMessage[messageType]
        {
            return NSError(domain: OPErrorContainer.kOperandoDomain, code: errorCode, userInfo: nil)
        }
        
        return OPErrorContainer.unknownError
    }
    
    static func parseIdentitiesList(from dataDict: [String: Any]) -> IdentitiesListResponse?
    {
        guard let identitiesArray = dataDict["identities"] as? [ [String: Any] ] else
        {
            return nil
        }
        
        var indexOfDefaultOne: Int = 0
        var identities: [String] = []
        
        for (index, dict) in identitiesArray.enumerated()
        {
            guard let email = dict["email"] as? String, let isDefault = dict["isDefault"] as? Bool else {
                return nil
            }
            
            if isDefault { indexOfDefaultOne = index}
            identities.append(email)
            
        }
        
        return IdentitiesListResponse(identitiesList: identities, indexOfDefaultIdentity: indexOfDefaultOne)
    }
    
    static func parseDomainsList(from dataDict: [String: Any]) -> [Domain]?
    {
        guard let domainsArray = dataDict["domains"] as? [ [String: Any] ] else{
            return nil
        }
        
        var domains: [Domain] = []
        
        for dict in domainsArray{
            guard let id = dict["id"] as? String, let name = dict["name"] as? String else {
                return nil
            }
            
            domains.append(Domain(id: id, name: name))
        }
        
        return domains
    }
    
    static func parseGeneratedIdentity(from dataDict: [String: Any]) -> String?
    {
        guard let emailDict = dataDict["generatedIdentity"] as? [String: Any],
              let email = emailDict["email"] as? String
        else
        {
            return nil
        }
        
        return email
    }
    
    
    static func parsePfbDeals(from dataDict: [String: Any]) -> [PfbDeal]?
    {
        guard let dealsArray = dataDict["deals"] as? [ [String: Any] ] else {
            return nil
        }
        
        var deals: [PfbDeal] = []
        
        for dict in dealsArray{
            if let pfbDeal = PfbDeal(dict: dict) {
                deals.append(pfbDeal)
            }
        }
        
        return deals
    }
    
    static func parseAddIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "createIdentity_success", in: dataDict)
    }
    
    static func parseDeleteIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "deleteIdentity_success", in: dataDict)
    }
    
    static func parseUpdateSubstituteIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "defaultIdentityUpdated", in: dataDict)
    }
    
    static func parseSubscribeToDealSuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "dealAccepted", in: dataDict)
    }
    
    static private func parseMetaCurrentPhaseEqualTo(item: String, in dataDict: [String: Any]) -> Bool?
    {
        guard let metaDict = dataDict["meta"] as? [String: Any],
            let currentPhaseStatus = metaDict["currentPhase"] as? String else
        {
            return nil
        }
        
        if currentPhaseStatus == item
        {
            return true
        }
        
        return nil
    }
    
}
