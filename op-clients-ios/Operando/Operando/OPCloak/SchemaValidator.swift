//
//  SchemaValidator.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol SchemaValidator {
    func validate(json: [String: Any], withSchema schema: [String: Any], completion: ((_ errorIfAny: NSError?) -> Void)?)
}




class SwiftSchemaValidator: SchemaValidator {
    
    let kiteValidator = KiteJSONValidator()
    func validate(json: [String : Any], withSchema schema: [String : Any], completion: ((NSError?) -> Void)?) {
        
        if self.kiteValidator.validateJSONInstance(json, withSchema: schema) {
            completion?(nil)
            return
        }
        
        completion?(.jsonNotValidAccordingToSchema)
        
    }
    
}
