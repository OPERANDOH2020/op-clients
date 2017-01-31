//
//  CommonUtils.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(AccessedSensor *)extractSensorOfType:(NSString *)type from:(NSArray<AccessedSensor *> *)sensors{
    
    for (AccessedSensor *sensor in sensors) {
        if ([sensor.sensorType isEqualToString:type]) {
            return sensor;
        }
    }
    
    return nil;
}

@end
