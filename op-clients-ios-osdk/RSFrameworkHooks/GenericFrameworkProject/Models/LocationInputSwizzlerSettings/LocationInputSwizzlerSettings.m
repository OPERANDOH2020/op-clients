//
//  LocationInputSwizzlerSettings.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSwizzlerSettings.h"

#pragma mark -

static NSString *kOverrideLatitudeKey = @"kOverrideLatitudeKey";
static NSString *kOverrideLongitudeKey = @"kOverrideLongitudeKey";
static NSString *kOverrideLocationEnabledKey = @"kOverrideLocationEnabledKey";

@interface LocationInputSwizzlerSettings()
@property (readwrite, assign, nonatomic) double locationLatitude;
@property (readwrite, assign, nonatomic) double locationLongitude;
@property (readwrite, assign, nonatomic) BOOL enabled;

@end

@implementation LocationInputSwizzlerSettings

+(LocationInputSwizzlerSettings *)createWithLatitude:(double)latitude longitude:(double)longitude enabled:(BOOL)enabled{
    
    LocationInputSwizzlerSettings *settings = [[LocationInputSwizzlerSettings alloc] init];
    settings.locationLatitude = latitude;
    settings.locationLongitude = longitude;
    settings.enabled = enabled;
    
    return settings;
    
}

+(LocationInputSwizzlerSettings *)createFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    LocationInputSwizzlerSettings *settings = [[LocationInputSwizzlerSettings alloc] init];
    
    settings.locationLatitude = [[defaults objectForKey:kOverrideLatitudeKey] doubleValue];
    settings.locationLongitude = [[defaults objectForKey:kOverrideLongitudeKey] doubleValue];
    settings.enabled = [[defaults objectForKey:kOverrideLocationEnabledKey] boolValue];
    
    return settings;
}

-(void)synchronizeToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.locationLatitude) forKey:kOverrideLatitudeKey];
    [defaults setObject:@(self.locationLongitude) forKey:kOverrideLongitudeKey];
    [defaults setObject:@(self.enabled) forKey:kOverrideLocationEnabledKey];
    [defaults synchronize];
}

@end
