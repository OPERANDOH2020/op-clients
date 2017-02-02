//
//  CommonUtils.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(AccessedInput *)extractInputOfType:(NSString *)type from:(NSArray<AccessedInput *> *)sensors{
    
    for (AccessedInput *sensor in sensors) {
        if ([sensor.inputType isEqualToString:type]) {
            return sensor;
        }
    }
    
    return nil;
}

@end
