//
//  LocationInputSwizzler.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInputSwizzlerSettings.h"
#import <CoreLocation/CoreLocation.h>

@protocol LocationInputAnalyzer <NSObject>
-(void)newUserLocationsRequested:(NSArray<CLLocation*>* _Nonnull)locations;
@end

@interface LocationInputSwizzler : NSObject

@property (readonly, nonatomic) LocationInputSwizzlerSettings *currentSettings;
-(void)applySettings:(LocationInputSwizzlerSettings*)settings;
-(void)reportInputToAnalyzer:(id<LocationInputAnalyzer> _Nullable)analyzer;

+(LocationInputSwizzler*)sharedInstance;

@end
