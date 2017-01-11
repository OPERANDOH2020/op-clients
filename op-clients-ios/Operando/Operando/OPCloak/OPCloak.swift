//
//  File.swift
//  Operando
//
//  Created by Costin Andronache on 12/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

let kURLSchema = "operando"

enum CertifiedAppRequestType: String {
    case TypeRegisterWithSCD = "TypeRegisterWithSCD"
    case TypeNotifyAboutAction = "TypeNotifyAboutAction"
}

let kURLParameterRequestType = "RequestType"
let kURLParameterJSONContent = "JSONContent"

enum SensorType: String {
    case Location = "loc"
    case Microphone = "mic"
    case Camera = "cam"
    case Gyroscope = "gyro"
    case Accelerometer = "acc"
    case Proximity = "prox"
    case TouchID = "touchID"
    case Barometer = "bar"
    case Force = "force"
    
    static let namesPerSensorType: [SensorType: String] = [ SensorType.Camera : "Camera",
                                                                    SensorType.Accelerometer : "Accelerometer",
                                                                    SensorType.Location : "Location",
                                                                    SensorType.Gyroscope: "Gyroscope",
                                                                    SensorType.Barometer: "Barometer",
                                                                    SensorType.Force: "Force touch",
                                                                    SensorType.Proximity: "Proximity",
                                                                    SensorType.TouchID: "TouchID",
                                                                    SensorType.Microphone: "Microphone"];}


struct ThirdParty {
    let name: String
    let url: String
    
    init?(dict: [String: Any]) {
        guard let name = dict["name"] as? String,
            let url = dict["url"] as? String  else {
                return nil
        }
        
        self.name = name
        self.url = url
    }
    
}

struct PrivacyDescription {
    static let maxPrivacyLevel = 6
    let privacyLevel: Int
    let thirdParty: ThirdParty?
    
    init?(dict: [String: Any]) {
        guard let privacyLevel = dict["privacyLevel"] as? Int,
            privacyLevel >= 1 && privacyLevel <= PrivacyDescription.maxPrivacyLevel else {
                return nil
        }
        
        self.privacyLevel = privacyLevel
        if let thirdPartyDict = dict["thirdParty"] as? [String: Any],
            let thirdParty = ThirdParty(dict: thirdPartyDict) {
            self.thirdParty = thirdParty
        } else {
            self.thirdParty = nil
        }
    }
}

struct AccessedSensor {
    let sensorType: SensorType
    let privacyDescription: PrivacyDescription
    let accessFrequency: String
    
    init?(dict: [String: Any]) {
        guard let type = dict["sensorType"] as? String,
              let sensorType = SensorType(rawValue: type),
              let pdDict = dict["privacyDescription"] as? [String: Any],
              let privacyDescription = PrivacyDescription(dict: pdDict),
              let accessFrequency = dict["accessFrequency"] as? String
               else {
                return nil
        }
        
        self.accessFrequency = accessFrequency
        self.sensorType = sensorType
        self.privacyDescription = privacyDescription
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
    let appIconURL: String?
    
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
        self.appIconURL = scd["appIconURL"] as? String
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
            
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "The document received is not a valid JSON")
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
        self.validate(scdDocument: scdDocument){ error in 
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.scdRepository.registerSCDJson(scdDocument) {
                if let error = $0 {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                 OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "Done");
            }
           
        }
    }
    
    private func processNotifyJSONContent(json: [String: Any]){
        
    }
    
    
    private func validate(scdDocument: [String: Any], completion: CallbackWithError?){
        self.schemaProvider.getSchemaWithCallback { (schema, error) in
            if let error = error {
                completion?(error)
            }
            guard let schema = schema else {
                return
            }
            
            self.schemaValidator.validate(json: scdDocument, withSchema: schema, completion: completion)
        }
    }
    
    
    private func buildRequestDict(from url: URL) -> [String: String] {
        let nameValuePairs = url.host?.components(separatedBy: "&") ?? []
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
