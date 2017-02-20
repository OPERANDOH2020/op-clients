//
//  LocationInputSwizzlerSettings.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInputSwizzlerSettings : NSObject

@property (readonly, nonatomic) double locationLatitude;
@property (readonly, nonatomic) double locationLongitude;
@property (readonly, nonatomic) BOOL enabled;

-(void)synchronizeToUserDefaults;

+(LocationInputSwizzlerSettings*)createWithLatitude:(double)latitude longitude:(double)longitude enabled:(BOOL)enabled;
+(LocationInputSwizzlerSettings*)createFromUserDefaults;

@end
