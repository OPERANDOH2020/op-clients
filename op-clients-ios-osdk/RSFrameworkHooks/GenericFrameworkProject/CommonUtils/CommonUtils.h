//
//  CommonUtils.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>

@interface CommonUtils : NSObject

+(AccessedSensor*)extractSensorOfType:(NSString*)type from:(NSArray<AccessedSensor*>*)sensors;

@end
