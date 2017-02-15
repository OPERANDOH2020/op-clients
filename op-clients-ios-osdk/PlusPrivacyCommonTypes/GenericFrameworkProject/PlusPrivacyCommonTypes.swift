//
//  PlusPrivacyCommonTypes.swift
//  Operando
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
@objc
public class AccessFrequencyType: NSObject {
    public static let SingularSample = "singularSample"
    public static let Continuous = "continuously"
    public static let ContinuousIntervals = "continuousIntervals"
    
    public static let accessFrequenciesDescriptions: [String: String] = [ AccessFrequencyType.Continuous : "The data is collected continuously throughout the lifetime of the app.",
                                                                           AccessFrequencyType.ContinuousIntervals: "The data is collected continuously in time intervals, triggered by certain events (e.g when the you presss Record/Stop or enter in a geofencing area)",
                                                                           AccessFrequencyType.SingularSample: "Only one sample of data is collected at certain times."]
    
    public static func isValid(rawValue: String) -> Bool {
        return self.accessFrequenciesDescriptions.keys.contains(rawValue)
    }
}


@objc
public class InputType: NSObject {
    public static let Location = "loc"
    public static let Microphone = "mic"
    public static let Camera = "cam"
    public static let Gyroscope = "gyro"
    public static let Accelerometer = "acc"
    public static let Proximity = "prox"
    public static let TouchID = "touchID"
    public static let Barometer = "bar"
    public static let Force = "force"
    public static let Pedometer = "pedo"
    public static let Magnetometer = "magneto"
    public static let Contacts = "contacts"
    
    public static let namesPerInputType: [String: String] = [ InputType.Camera : "Camera",
                                                               InputType.Accelerometer : "Accelerometer",
                                                               InputType.Location : "Location",
                                                               InputType.Gyroscope: "Gyroscope",
                                                               InputType.Barometer: "Barometer",
                                                               InputType.Force: "Force touch",
                                                               InputType.Proximity: "Proximity",
                                                               InputType.TouchID: "TouchID",
                                                               InputType.Microphone: "Microphone",
                                                               InputType.Pedometer: "Pedometer",
                                                               InputType.Magnetometer: "Magnetometer",
                                                               InputType.Contacts: "Contacts"];
    
    
    public static func isValidInputType(sensorType: String) -> Bool {
        return self.namesPerInputType.keys.contains(sensorType)
    }
}

@objc
public class ThirdParty: NSObject {
    public let name: String
    public let url: String
    
    public init?(dict: [String: Any]) {
        guard let name = dict["name"] as? String,
            let url = dict["url"] as? String  else {
                return nil
        }
        
        self.name = name
        self.url = url
    }
    
}

@objc
public class PrivacyDescription: NSObject {
    public static let maxPrivacyLevel = 6
    public let privacyLevel: Int
    public let thirdParties: [ThirdParty]
    
    public init?(dict: [String: Any]) {
        guard let privacyLevel = dict["privacyLevel"] as? Int,
            privacyLevel >= 1 && privacyLevel <= PrivacyDescription.maxPrivacyLevel else {
                return nil
        }
        
        
        var parties: [ThirdParty] = []
        
        self.privacyLevel = privacyLevel
        if let thirdPartiesDictArray = dict["thirdParties"] as? [[String: Any]] {
            thirdPartiesDictArray.forEach { if let tp = ThirdParty(dict: $0) { parties.append(tp)} }
        }
        
        self.thirdParties = parties
    }
}

@objc
public class AccessedInput: NSObject {
    public let inputType: String
    public let privacyDescription: PrivacyDescription
    public let accessFrequency: String
    public let userControl: Bool
    
    public init?(dict: [String: Any]) {
        guard let inputType = dict["inputType"] as? String,
            InputType.isValidInputType(sensorType: inputType),
            let pdDict = dict["privacyDescription"] as? [String: Any],
            let privacyDescription = PrivacyDescription(dict: pdDict),
            let accessFrequency = dict["accessFrequency"] as? String,
            let userControl = dict["userControl"] as? Bool
            else {
                return nil
        }
        
        self.accessFrequency = accessFrequency
        self.inputType = inputType
        self.privacyDescription = privacyDescription
        self.userControl = userControl
    }
    
    
    public static func buildFromJsonArray(_ array: [[String: Any]]) -> [AccessedInput]? {
        var result: [AccessedInput] = []
        
        for dict in array {
            guard let item = AccessedInput(dict: dict) else {
                return nil
            }
            result.append(item)
        }
        
        return result
    }
}


@objc
public class SCDDocument: NSObject {
    public let appTitle: String
    public let bundleId: String
    public let appIconURL: String?
    
    public let accessedLinks: [String]
    public let accessedInputs: [AccessedInput]
    
    internal init?(scd: [String: Any]) {
        guard let title = scd["title"] as? String,
            let bundleId = scd["bundleId"] as? String,
            let accessedLinks = scd["accessedLinks"] as? [String],
            let accessedSensorsDictArray = scd["accessedInputs"] as? [[String: Any]],
            let accessedSensors = AccessedInput.buildFromJsonArray(accessedSensorsDictArray) else {
                return nil
        }
        
        self.appTitle = title
        self.bundleId = bundleId
        self.accessedInputs = accessedSensors
        self.accessedLinks = accessedLinks
        self.appIconURL = scd["appIconURL"] as? String
    }
    
}
