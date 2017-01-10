//
//  SCDSensorCell.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class SCDSensorCell: UITableViewCell {
    static let identifierNibName = "SCDSensorCell"
    
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var privacyLevelLabel: UILabel!
    
    private static let namesPerSensorType: [SensorType: String] = [ SensorType.Camera : "Camera",
                                                                    SensorType.Accelerometer : "Accelerometer",
                                                                    SensorType.Location : "Location",
                                                                    SensorType.Gyroscope: "Gyroscope",
                                                                    SensorType.Barometer: "Barometer",
                                                                    SensorType.Force: "Force touch",
                                                                    SensorType.Proximity: "Proximity",
                                                                    SensorType.TouchID: "TouchID",
                                                                    SensorType.Microphone: "Microphone"];
    
    private static let colorsPerPrivacyLevel: [UIColor] = [.colorWith(51, 102, 255, 0.7),
                                                           .colorWith(255, 255, 0, 0.7),
                                                           .colorWith(255, 204, 0, 0.7),
                                                           .colorWith(255, 153, 0, 0.7),
                                                           .colorWith(255, 102, 0, 0.7),
                                                           .colorWith(255, 0, 0, 0.7)];
    
    
    func setupWith(sensor: AccessedSensor) {
        self.sensorNameLabel.text = SCDSensorCell.namesPerSensorType[sensor.sensorType]
        self.privacyLevelLabel.text = "PL\(sensor.privacyLevel)"
        if sensor.privacyLevel >= 1 && sensor.privacyLevel <= SCDSensorCell.colorsPerPrivacyLevel.count {
            self.contentView.backgroundColor = SCDSensorCell.colorsPerPrivacyLevel[sensor.privacyLevel - 1]
        }
    }
    
}
