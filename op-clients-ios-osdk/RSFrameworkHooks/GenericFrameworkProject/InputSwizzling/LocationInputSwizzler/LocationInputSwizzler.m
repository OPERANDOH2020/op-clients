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
@property (strong, nonatomic) RandomWalkSwizzlerSettings *currentSettings;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, WeakDelegateHolder*> *delegatePerInstance;
@property (strong, nonatomic) NSMutableArray<CurrentActiveLocationIndexChangedCallback> *callbacksToNotifyChange;
@property (strong, nonatomic) LocationsCallback whenLocationsAreRequested;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger indexOfCurrentSentLocation;
@end


@implementation LocationInputSwizzler

-(void)setupWithSettings:(RandomWalkSwizzlerSettings *)settings eventsDispatcher:(PPEventDispatcher *)eventsDispatcher whenLocationsAreRequested:(LocationsCallback)whenLocationsAreRequested {
    
    self.callbacksToNotifyChange = [[NSMutableArray alloc] init];
    
    [self applyNewSettings:settings];
    
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

-(void)registerNewChangeCallback:(CurrentActiveLocationIndexChangedCallback)callback {
    if (![self.callbacksToNotifyChange containsObject:callback]) {
        [self.callbacksToNotifyChange addObject:callback];
    }
}

-(void)removeChangeCallback:(CurrentActiveLocationIndexChangedCallback)callback {
    [self.callbacksToNotifyChange removeObject:callback];
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


-(void)applyNewSettings:(RandomWalkSwizzlerSettings *)settings {
    self.currentSettings = settings;
    [self.timer invalidate];
    self.indexOfCurrentSentLocation = 0;
    
    if (!settings.enabled) {
        return;
    }
    
    __block NSInteger direction = 1;
    WEAKSELF
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        weakSelf.indexOfCurrentSentLocation += direction;
        if (weakSelf.indexOfCurrentSentLocation < 0) {
            weakSelf.indexOfCurrentSentLocation = 0;
            direction = 1;
            
        } else {
            if (weakSelf.indexOfCurrentSentLocation >= settings.walkPath.count) {
                weakSelf.indexOfCurrentSentLocation = settings.walkPath.count - 1;
                direction = -1;
            }
        }
        for (CurrentActiveLocationIndexChangedCallback callback in weakSelf.callbacksToNotifyChange) {
            callback(weakSelf.indexOfCurrentSentLocation);
        }
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:operation selector:@selector(main) userInfo:nil repeats:YES];
    
}

-(CLLocation*)locationSubstituteIfAny {
    if (!(self.currentSettings && self.currentSettings.enabled)) {
        return nil;
    }
    
    if (self.indexOfCurrentSentLocation < 0 || self.indexOfCurrentSentLocation >= self.currentSettings.walkPath.count) {
        return nil;
    }
    
    return self.currentSettings.walkPath[self.indexOfCurrentSentLocation];
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
    
    WeakDelegateHolder *holder = self.delegatePerInstance[@(manager.hash)];
    [holder.delegate locationManager:manager didUpdateLocations:locationsForDelegates];
    SAFECALL(self.whenLocationsAreRequested, locationsForDelegates)
}

@end

