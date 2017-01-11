//
//  EULATextBuilder.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class EULATextBuilder: NSObject {

    
    private static let privacyLevelShortNames: [Int: String] = [1: "Local-Only", 2: "Only-Aggregate", 3: "DP-Compatible", 4: "Self-Use Only",
                                                                5: "ThirdParty-Shared", 6: "Unspecified-Usages"]
    
    
    private static let privacyLevelDescriptions: [Int: String] = [:]
    
    static func generateEULAFrom(scd: SCDDocument) -> NSAttributedString {
        let ms = NSMutableAttributedString()
        
        
        return ms;
    }
    
    
    private static func buildIntro(for scd: SCDDocument) -> NSAttributedString {
        
        let attrString = NSAttributedString(string: "By using \(scd.appTitle) you agree to the following terms of usage of your data that may or may not affect your privacy.")
        
        return attrString
    }
    
    private static func buildDownloadDataPart(for scd: SCDDocument) -> NSAttributedString {
        guard scd.accessedLinks.count > 0 else {
            return NSAttributedString(string: "")
        }
        
        var story: String = "The app downloads data from the following third party sources:";
        for urlSource in scd.accessedLinks {
            story.append("\n" + urlSource)
        }
        
        story.append("\nDownloading data may be based on your input, for example a search keyword that you type in a text field. You should check the app's Privacy Policy to see whether this data is tracked and / or how it is used.")
        
        return NSAttributedString(string: story)
    }
    
    
    private static func buildSensorsPart(for scd: SCDDocument) -> NSAttributedString {
        guard scd.accessedSensors.count > 0 else {
            return NSAttributedString(string: "")
        }
        
        
        var story: String = ""
        
        var sensors = scd.accessedSensors.sorted(by: { s1, s2 in
            return s1.privacyDescription.privacyLevel > s2.privacyDescription.privacyLevel
        })
        
        
        
        return NSAttributedString(string: story)
    }
    
    
    private static func agreggateBasedOnPrivacyLevel(sensors: [AccessedSensor]) -> [Int: [AccessedSensor]] {
        var result: [Int: [AccessedSensor]] = [:]
        for i in 1...PrivacyDescription.maxPrivacyLevel {
            result[i] = []
        }
        
        for sensor in sensors {
            result[sensor.privacyDescription.privacyLevel]?.append(sensor)
        }
        
        return result
    }
    
    
}
