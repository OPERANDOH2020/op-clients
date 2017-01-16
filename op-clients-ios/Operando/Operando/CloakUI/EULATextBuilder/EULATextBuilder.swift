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
    
    
    
    
    private static let accessFrequenciesDescriptions: [AccessFrequency: String] = [ .Continuous : "The data is collected continuously throughout the lifetime of the app, and the user has no control of this. Generally this applies to location-aware apps.",
        .ContinuousIntervals: ""]
    
    
    static func generateEULAFrom(scd: SCDDocument) -> NSAttributedString {
        let ms = NSMutableAttributedString()
        
        ms.append(EULATextBuilder.buildIntro(for: scd))
        ms.append(NSAttributedString(string: "\n\n"))
        ms.append(EULATextBuilder.buildDownloadDataPart(for: scd))
        ms.append(NSAttributedString(string: "\n\n"))
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
        
        var story: String = "The app downloads data from the following third party sources:\n";
        for urlSource in scd.accessedLinks {
            story.append("\n" + urlSource)
        }
        
        story.append("\n\nDownloading data may be based on your input, for example a search keyword that you type in a text field. You should check the app's Privacy Policy to see whether this data is tracked and / or how it is used.")
        
        return NSAttributedString(string: story)
    }
    
    
    private static func buildSensorsPart(for scd: SCDDocument) -> NSAttributedString {
        guard scd.accessedSensors.count > 0 else {
            return NSAttributedString(string: "")
        }
        
        
        var story: String = ""
        
        let aggregatedSensors = EULATextBuilder.agreggateBasedOnPrivacyLevel(sensors: scd.accessedSensors)
        
        for i in (1...PrivacyDescription.maxPrivacyLevel).reversed() {
            if let sensorsAtI = aggregatedSensors[i], sensorsAtI.count > 0 {
                var sensorsNames: String = ""
                sensorsAtI.forEach {sensorsNames.append("\(SensorType.namesPerSensorType[$0.sensorType] ?? ""), ")}
                story.append("The following sensor");
                if sensorsAtI.count > 1 { story.append("s, ")} else {story.append(", ")}
                story.append(sensorsNames)
                if sensorsAtI.count > 1 { story.append("are ") } else {story.append("is ")}
                
                story.append(" located under the privacy level PL\(i), that is \"\(EULATextBuilder.privacyLevelShortNames[i] ?? "")\". ")
                story.append(EULATextBuilder.privacyLevelDescriptions[i] ?? "")
                
                if i == 5 {
                    story.append("\nThese are listed as follows:\n\n")
                    sensorsAtI.forEach {
                        story.append("For \(SensorType.namesPerSensorType[$0.sensorType] ?? "")\n\n")
                        story.append(EULATextBuilder.buildLevel5ThirdPartiesText(from: $0))
                    }
                }
                
                story.append("\n");
            }
        }
        
        return NSAttributedString(string: story)
    }
    
    
    
    
    private static func buildLevel5ThirdPartiesText(from sensor: AccessedSensor) -> String {
        guard sensor.privacyDescription.thirdParties.count > 0 else {
            return "-There are no third parties specified for this sensor-"
        }
        var story = ""
        sensor.privacyDescription.thirdParties.forEach { tp in
            
            story.append("\(tp.name)\n")
            story.append("\(tp.url)\n\n")
        }
        
        return story
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
    
    
    private static func buildAccessFrequencyPart(from document: SCDDocument) -> NSAttributedString {
        let ms = NSMutableAttributedString()
        
        var sensorsPerAccessFrequency = EULATextBuilder.aggregateBasedOnAccessFrequensy(sensors: document.accessedSensors)
        
        return ms
    }
    
    private static func aggregateBasedOnAccessFrequensy(sensors: [AccessedSensor]) -> [AccessFrequency: [AccessedSensor]] {
        var result: [AccessFrequency: [AccessedSensor]] = [:]
        for af in [AccessFrequency.Continuous, AccessFrequency.ContinuousIntervals, AccessFrequency.SingularSample] {
            result[af] = []
        }
        
        sensors.forEach { sensor in
            guard let af = AccessFrequency(rawValue: sensor.accessFrequency) else {
                return
            }
            result[af]?.append(sensor)
        }
        
        return result
    }
    
}
