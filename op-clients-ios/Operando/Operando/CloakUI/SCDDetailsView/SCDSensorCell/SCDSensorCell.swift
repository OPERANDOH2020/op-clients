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
    

    
    private static let colorsPerPrivacyLevel: [UIColor] = [.colorWith(51, 102, 255, 0.7),
                                                           .colorWith(255, 255, 0, 0.7),
                                                           .colorWith(255, 204, 0, 0.7),
                                                           .colorWith(255, 153, 0, 0.7),
                                                           .colorWith(255, 102, 0, 0.7),
                                                           .colorWith(255, 0, 0, 0.7)];
    
    
    func setupWith(sensor: AccessedSensor) {
        let privacyLevel = sensor.privacyDescription.privacyLevel
        self.sensorNameLabel.text = SensorType.namesPerSensorType[sensor.sensorType]
        self.privacyLevelLabel.text = "PL\(privacyLevel)"
        if privacyLevel >= 1 && privacyLevel <= SCDSensorCell.colorsPerPrivacyLevel.count {
            self.contentView.backgroundColor = SCDSensorCell.colorsPerPrivacyLevel[privacyLevel - 1]
        }
    }
    
}
