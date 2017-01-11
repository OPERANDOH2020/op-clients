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
    
    
    private static let privacyLevelDescriptions: [Int: String] = [1: "The data collected under this privacy level is used locally only.",
                                                                  2: "Under this privacy level, bulks of data are sent to the vendor of the app, in an anonymised method (i.e. via https) and they may link the data to your account/ id if any.",
                                                                  3: "Bulks of data are sent securely (i.e via https) to the vendor of the app, in a manner that guarantees the data does not link back to your account/id if any.",
                                                                  4: "De discutat cu Sinica",
                                                                  5: "The data is shared with a list of of specfied third parties",
                                                                  6: "The vendor of the app does not disclose the manner in which this data is used."]
    
    static func generateEULAFrom(scd: SCDDocument) -> NSAttributedString {
        let ms = NSMutableAttributedString()
        
        ms.append(EULATextBuilder.buildIntro(for: scd))
        ms.append(NSAttributedString(string: "\n"))
        ms.append(EULATextBuilder.buildDownloadDataPart(for: scd))
        ms.append(NSAttributedString(string: "\n"))
        ms.append(EULATextBuilder.buildSensorsPart(for: scd));
        
        
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
        
        let aggregatedSensors = EULATextBuilder.agreggateBasedOnPrivacyLevel(sensors: scd.accessedSensors)
        
        for i in (1...PrivacyDescription.maxPrivacyLevel).reversed() {
            if let sensorsAtI = aggregatedSensors[i] {
                var sensorsNames: String = ""
                sensorsAtI.forEach {sensorsNames.append(", \(SensorType.namesPerSensorType[$0.sensorType])")}
                story.append("The following sensor");
                if sensorsAtI.count > 1 { story.append("s are")} else {story.append(" is")}
                story.append(" located under the privacy level PL\(i).")
                story.append(EULATextBuilder.privacyLevelDescriptions[i] ?? "")
                story.append("\n");
            }
        }
        
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
