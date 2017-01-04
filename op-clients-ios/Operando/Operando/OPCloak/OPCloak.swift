//
//  File.swift
//  Operando
//
//  Created by Costin Andronache on 12/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

let kURLSchema = "operando://"

enum CertifiedAppRequestType: String {
    case TypeRegisterWithSCD = "TypeRegisterWithSCD"
    case TypeNotifyAboutAction = "TypeNotifyAboutAction"
}

let kURLParameterRequestType = "RequestType"
let kURLParameterJSONContent = "JSONContent"


struct AccessedSensor {
    let sensorType: String
    let privacyLevel: Int
    
    init?(dict: [String: Any]) {
        guard let type = dict["sensorType"] as? String,
            let level = dict["privacyLevel"] as? Int else {
                return nil
        }
        
        self.privacyLevel = level
        self.sensorType = type
    }
    
    
    static func buildFromJsonArray(_ array: [[String: Any]]) -> [AccessedSensor]? {
        var result: [AccessedSensor] = []
        
        for dict in array {
            guard let item = AccessedSensor(dict: dict) else {
                return nil
            }
            result.append(item)
        }
        
        
        return result
    }
}

struct SCDDocument {
    let appTitle: String
    let bundleId: String
    let accessedLinks: [String]
    let accessedSensors: [AccessedSensor]
    
    init?(scd: [String: Any]) {
        guard let title = scd["title"] as? String,
              let bundleId = scd["bundleId"] as? String,
              let accessedLinks = scd["accessedLinks"] as? [String],
              let accessedSensorsDictArray = scd["accessedSensors"] as? [[String: Any]],
              let accessedSensors = AccessedSensor.buildFromJsonArray(accessedSensorsDictArray) else {
                return nil
        }
        
        self.appTitle = title
        self.bundleId = bundleId
        self.accessedSensors = accessedSensors
        self.accessedLinks = accessedLinks
    }
    
    
    static func buildFromJSON(array: [[String: Any]]) -> [SCDDocument]? {
        var items: [SCDDocument] = []
        
        for dict in array {
            guard let item = SCDDocument(scd: dict) else {
                return nil
            }
            
            items.append(item)
        }
        
        return items
    }
}

class OPCloak {
    
    private let schemaProvider: SchemaProvider
    private let schemaValidator: SchemaValidator
    private let scdRepository: SCDRepository
    
    init(schemaProvider: SchemaProvider,
         schemaValidator: SchemaValidator,
         scdRepository: SCDRepository) {
        self.schemaProvider = schemaProvider
        self.schemaValidator = schemaValidator
        self.scdRepository = scdRepository
    }
    
    func canProcess(url: URL) -> Bool {
        guard let scheme = url.scheme, scheme == kURLSchema else {
            return false
        }
        
        return true
    }
    
    func processIncoming(url: URL) {
        let requestDict = self.buildRequestDict(from: url)
        
        guard let messageType = requestDict[kURLParameterRequestType],
              let jsonContentURLEncoded = requestDict[kURLParameterJSONContent],
              let jsonData = jsonContentURLEncoded.removingPercentEncoding?.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments),
              let json = jsonObject as? [String: Any] else {
            return
        }
        
        if messageType == CertifiedAppRequestType.TypeRegisterWithSCD.rawValue {
            self.processRegisterJSONContent(scdDocument: json)
        }
        
        if messageType == CertifiedAppRequestType.TypeNotifyAboutAction.rawValue {
            self.processNotifyJSONContent(json: json)
        }
    }
    
    
    
    
    private func processRegisterJSONContent(scdDocument: [String: Any]){
        guard let scd = SCDDocument(scd: scdDocument) else {
            return
        }
        self.scdRepository.registerSCDJson(scdDocument, withCompletion: nil)
    }
    
    private func processNotifyJSONContent(json: [String: Any]){
        
    }
    
    
    private func validate(scdDocument: [String: Any], completion: VoidBlock?){
        self.schemaProvider.getSchemaWithCallback { (schema, error) in
            guard let schema = schema else {
                return
            }
            
            self.schemaValidator.validate(json: scdDocument, withSchema: schema) { error in
                if error == nil {
                    completion?()
                }
            }
        }
    }
    
    
    private func buildRequestDict(from url: URL) -> [String: String] {
        let nameValuePairs = url.path.components(separatedBy: "&")
        var requestDict: [String: String] = [:]
        for pair in nameValuePairs {
            let components = pair.components(separatedBy: "=")
            guard let name = components.first,
                let last = components.last else {
                    return [:]
            }
            
            requestDict[name] = last
        }
        
        return requestDict
    }
}
