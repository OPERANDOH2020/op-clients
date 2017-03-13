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



@interface CLLocationManager(LocationInputSwizzler)
-(void)ppLocSwizzling_setDelegate:(id<CLLocationManagerDelegate>)delegate;
@end



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
@property (weak, nonatomic) id<LocationInputAnalyzer> analyzer;
@end


@implementation LocationInputSwizzler

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

-(void)reportInputToAnalyzer:(id<LocationInputAnalyzer>)analyzer{
    self.analyzer = analyzer;
}

-(void)applySettings:(LocationInputSwizzlerSettings *)settings {
    self.currentSettings = settings;
}

-(CLLocation*)locationSubstituteIfAny {
    if (!(self.currentSettings && self.currentSettings.enabled)) {
        return nil;
    }
    
    return [[CLLocation alloc] initWithLatitude:self.currentSettings.locationLatitude longitude:self.currentSettings.locationLongitude];
}

-(CLLocation*)locationSubstituteIfAnyForActualLocation:(CLLocation*)actualLocation {
    if (actualLocation) {
        [self.analyzer newUserLocationsRequested:@[actualLocation]];
    }
    
    return [self locationSubstituteIfAny];
}

-(void)didAskToSetDelegate:(id<CLLocationManagerDelegate>)delegate onInstance:(CLLocationManager*)instance {
    
    if (delegate == nil) {
        self.delegatePerInstance[@(instance.hash)] = nil;
        [instance ppLocSwizzling_setDelegate: nil];
        return;
    }
    
    [instance ppLocSwizzling_setDelegate:self];
    
    WeakDelegateHolder *newHolder = [[WeakDelegateHolder alloc] init];
    newHolder.delegate = delegate;
    
    [self.delegatePerInstance setObject:newHolder forKey:@(instance.hash)];
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
    [self.analyzer newUserLocationsRequested:locations];
}

@end


@implementation CLLocationManager(LocationInputSwizzler)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")){
        [self jr_swizzleMethod:@selector(location) withMethod:@selector(ppLocSwizzling_location) error:nil];
        
        [self jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(ppLocSwizzling_setDelegate:) error:nil];
    }
}

-(void)ppLocSwizzling_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    [[LocationInputSwizzler sharedInstance] didAskToSetDelegate:delegate onInstance:self];
}

-(CLLocation *)ppLocSwizzling_location {
    
    CLLocation *actualLocation = [self ppLocSwizzling_location];
    CLLocation *loc = [[LocationInputSwizzler sharedInstance] locationSubstituteIfAnyForActualLocation:actualLocation];
    if (!loc) {
        return actualLocation;
    }
    return loc;
}

@end
