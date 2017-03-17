//
//  LocationInputSwizzler.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSwizzler.h"
#import <CoreLocation/CoreLocation.h>
#import "JRSwizzle.h"
#import "Common.h"
#import <PPApiHooks/PPApiHooks.h>

#pragma mark - Helper class to contain location manager's delegate

@interface WeakDelegateHolder : NSObject
@property (weak, nonatomic) id<CLLocationManagerDelegate> delegate;
@end

@implementation WeakDelegateHolder
@end

#pragma mark -

@interface LocationInputSwizzler() <CLLocationManagerDelegate>
@property (strong, nonatomic) LocationInputSwizzlerSettings *currentSettings;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, WeakDelegateHolder*> *delegatePerInstance;

@property (strong, nonatomic) LocationsCallback whenLocationsAreRequested;
@end


@implementation LocationInputSwizzler

-(void)setupWithSettings:(LocationInputSwizzlerSettings *)settings eventsDispatcher:(PPEventDispatcher *)eventsDispatcher whenLocationsAreRequested:(LocationsCallback)whenLocationsAreRequested {
    self.currentSettings = settings;
    self.whenLocationsAreRequested = whenLocationsAreRequested;
    __weak typeof(self) weakSelf = self;
    
    [eventsDispatcher insertNewHandlerAtTop:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventType == EventLocationManagerGetCurrentLocation) {
            [weakSelf processAskForLocationEvent:event];
        }
        
        if (event.eventType == EventLocationManagerSetDelegate) {
            [weakSelf processSetDelegateEvent:event];
        }
        
        SAFECALL(nextHandlerIfAny)
        
    }];
}

+(LocationInputSwizzler *)sharedInstance {
    static LocationInputSwizzler* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocationInputSwizzler alloc] init];
    });
    
    return  _sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.delegatePerInstance = [[NSMutableDictionary alloc] init];
    }

    return self;
}


-(void)applyNewSettings:(LocationInputSwizzlerSettings *)settings {
    self.currentSettings = settings;
}

-(CLLocation*)locationSubstituteIfAny {
    if (!(self.currentSettings && self.currentSettings.enabled)) {
        return nil;
    }
    
    return [[CLLocation alloc] initWithLatitude:self.currentSettings.locationLatitude longitude:self.currentSettings.locationLongitude];
}



-(void)processAskForLocationEvent:(PPEvent*)event {
    CLLocation *location = event.eventData[kPPLocationManagerGetCurrentLocationValue];
    CLLocation *modifiedLocation = [self locationSubstituteIfAny];
    
    if (!modifiedLocation) {
        if (location) {
            SAFECALL(self.whenLocationsAreRequested, @[location])
        }
        return;
    }
    
    [event.eventData setObject:modifiedLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    
    SAFECALL(self.whenLocationsAreRequested, @[modifiedLocation])
}

-(void)processSetDelegateEvent:(PPEvent*)event {
    id<CLLocationManagerDelegate> delegate = event.eventData[kPPLocationManagerDelegate];
    CLLocationManager *instance = event.eventData[kPPLocationManagerInstance];
    PPVoidBlock setDelegateConfirmation = event.eventData[kPPLocationManagerSetDelegateConfirmation];
    
    if (delegate == nil) {
        self.delegatePerInstance[@(instance.hash)] = nil;
        SAFECALL(setDelegateConfirmation)
        return;
    }
    
    [event.eventData setObject:self forKey:kPPLocationManagerDelegate];
    
    WeakDelegateHolder *newHolder = [[WeakDelegateHolder alloc] init];
    newHolder.delegate = delegate;
    
    [self.delegatePerInstance setObject:newHolder forKey:@(instance.hash)];
    SAFECALL(setDelegateConfirmation)
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSArray *locationsForDelegates = nil;
    CLLocation *replacedLocation = [self locationSubstituteIfAny];
    if (replacedLocation) {
        locationsForDelegates = @[replacedLocation];
    } else {
        locationsForDelegates = locations;
    }
    
    WeakDelegateHolder *holder  = self.delegatePerInstance[@(manager.hash)];
    [holder.delegate locationManager:manager didUpdateLocations:locationsForDelegates];
    SAFECALL(self.whenLocationsAreRequested, locationsForDelegates)
}

@end

