//
//  RandomWalkSwizzlerSettings.m
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "RandomWalkSwizzlerSettings.h"


@interface RandomWalkSwizzlerSettings()
@property (readwrite, strong, nonatomic) RandomWalkBoundCircle *boundCircle;
@property (readwrite, strong, nonatomic) NSArray<CLLocation*> *walkPath;
@property (readwrite, assign, nonatomic) BOOL enabled;
@end


@implementation RandomWalkSwizzlerSettings

+(RandomWalkSwizzlerSettings *)createFromDefaults:(NSUserDefaults *)defaults error:(NSError *__autoreleasing *)error {
    RandomWalkSwizzlerSettings *settings = [[RandomWalkSwizzlerSettings alloc] init];
    
    settings.enabled = [defaults boolForKey:kRandomWalkEnabled];
    
    NSArray *latitudesArray = [defaults arrayForKey:kRandomWalkPathLatitudes];
    NSArray *longitudesArray = [defaults arrayForKey:kRandomWalkPathLongitudes];
    
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
    
    return settings;
}

@end
