//
//  Swarm.swift
//  SwarmClientTest
//
//  Created by Catalin Pomirleanu on 4/28/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

enum SwarmParameters: String {
    case SwarmingName       = "swarmingName"
    case Phase              = "phase"
    case Command            = "command"
    case Ctor               = "ctor"
    case TenantId           = "tenantId"
    case CommandArguments   = "commandArguments"
    
    case Meta               = "meta"
}

class Swarm: NSObject {
    
    class func getSwarmDictionary(tenandId: String, swarmName: String, phase: String, ctor: String, arguments: [AnyObject]) -> NSDictionary {
        let swarmDate = NSMutableDictionary()
        let swarmMeta = NSMutableDictionary()
        
        swarmMeta[SwarmParameters.SwarmingName.rawValue] = swarmName
        swarmMeta[SwarmParameters.Phase.rawValue] = phase
        swarmMeta[SwarmParameters.Command.rawValue] = "start"
        swarmMeta[SwarmParameters.Ctor.rawValue] = ctor
        swarmMeta[SwarmParameters.TenantId.rawValue] = tenandId
        swarmMeta[SwarmParameters.CommandArguments.rawValue] = arguments
        
        swarmDate[SwarmParameters.Meta.rawValue] = swarmMeta
        
        return swarmDate
    }
}