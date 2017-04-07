//
//  LocationInputSwizzler.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefinedLocationsSwizzlerSettings.h"
#import <CoreLocation/CoreLocation.h>
#import <PPApiHooks/PPApiHooks.h>
#import "CommonLocationViewModels.h"

typedef void(^LocationsCallback)(NSArray<CLLocation*>* _Nonnull locations);

@interface LocationInputSwizzler : NSObject

@property (readonly, nonatomic, nullable) UserDefinedLocationsSwizzlerSettings *currentSettings;

-(void)setupWithSettings:(UserDefinedLocationsSwizzlerSettings* _Nullable)settings eventsDispatcher:(PPEventDispatcher* _Nonnull)eventsDispatcher whenLocationsAreRequested:(LocationsCallback _Nonnull)whenLocationsAreRequested;
-(void)applyNewSettings:(UserDefinedLocationsSwizzlerSettings* _Nonnull)settings;

-(void)registerNewChangeCallback:(CurrentActiveLocationIndexChangedCallback _Nonnull)callback;
-(void)removeChangeCallback:(CurrentActiveLocationIndexChangedCallback _Nonnull)callback;

@end
