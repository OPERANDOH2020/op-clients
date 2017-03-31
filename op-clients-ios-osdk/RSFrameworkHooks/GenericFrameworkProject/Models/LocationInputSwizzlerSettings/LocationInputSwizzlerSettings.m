//
//  LocationInputSwizzlerSettings.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSwizzlerSettings.h"

#pragma mark -

static NSString *kOverrideLocationEnabledKey = @"kOverrideLocationEnabledKey";
static NSString *kOverrideLocationLatitudesKey = @"kOverrideLocationLatitudesKey";
static NSString *kOverrideLocationLongitudesKey = @"kOverrideLocationLongitudesKey";
static NSString *kOverrideLocationCycleKey = @"kOverrideLocationCycleKey";
static NSString *kOverrideLocationChangeInterval = @"kOverrideLocationChangeInterval";

@interface LocationInputSwizzlerSettings()

@property (readwrite, nonatomic, strong) NSArray<CLLocation*> *locations;
@property (readwrite, assign, nonatomic) BOOL enabled;
@property (readwrite, assign, nonatomic) BOOL cycle;
@property (readwrite, assign, nonatomic) NSTimeInterval changeInterval;
@end

@implementation LocationInputSwizzlerSettings

+(LocationInputSwizzlerSettings *)createWithLocations:(NSArray<CLLocation *> *)locations enabled:(BOOL)enabled cycle:(BOOL)cycle changeInterval:(NSTimeInterval)changeInterval{
    
    LocationInputSwizzlerSettings *settings = [[LocationInputSwizzlerSettings alloc] init];
    settings.enabled = enabled;
    settings.cycle = cycle;
    settings.locations = locations;
    
    return settings;
    
}

+(LocationInputSwizzlerSettings *)createFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    LocationInputSwizzlerSettings *settings = [[LocationInputSwizzlerSettings alloc] init];
    
    NSArray<NSNumber*> *latitudes = [defaults objectForKey:kOverrideLocationLatitudesKey];
    NSArray<NSNumber*> *longitudes = [defaults objectForKey:kOverrideLocationLongitudesKey];
    NSMutableArray<CLLocation*> *locations = [[NSMutableArray alloc] init];
    
    if (latitudes.count == longitudes.count) {
        for (int i=0; i<latitudes.count; i++) {
            NSNumber *latitude = latitudes[i];
            NSNumber *longitude = longitudes[i];
            if ([latitude isKindOfClass:[NSNumber class]] && [longitude isKindOfClass:[NSNumber class]]) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
                [locations addObject:location];
            }
        }
    }
    
    settings.enabled = [[defaults objectForKey:kOverrideLocationEnabledKey] boolValue];
    settings.changeInterval = [[defaults objectForKey:kOverrideLocationChangeInterval] doubleValue];
    settings.cycle = [[defaults objectForKey:kOverrideLocationCycleKey] boolValue];
    
    return settings;
}

-(void)synchronizeToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.enabled) forKey:kOverrideLocationEnabledKey];
    [defaults synchronize];
}

@end
