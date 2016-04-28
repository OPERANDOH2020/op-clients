//
//  SwarmClientErrorGenerator.swift
//  SwarmClientTest
//
//  Created by Catalin Pomirleanu on 4/28/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let SwarmClientErrorDomain = "operando.error.domain"

public enum SwarmClientErrorCode: Int {
    case InvalidURLError   = 10001
}

class SwarmClientErrorGenerator: NSObject {

    class func getInvalidURLError() -> NSError {
        return NSError(domain: SwarmClientErrorDomain, code: SwarmClientErrorCode.InvalidURLError.rawValue, userInfo: nil)
    }
}
