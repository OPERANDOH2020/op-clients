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







#pragma mark - Helper class to contain location manager's delegate

@interface WeakDelegateHolder : NSObject
@property (weak, nonatomic) id<CLLocationManagerDelegate> delegate;
@property (strong, nonatomic) void (^whenDelegateSetToNil)();
@end

@implementation WeakDelegateHolder
-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate {
    _delegate = delegate;
    if (!delegate) {
        SAFECALL(self.whenDelegateSetToNil)
    }
}
@end

#pragma mark -

@interface LocationInputSwizzler() <CLLocationManagerDelegate>
@property (strong, nonatomic) LocationInputSwizzlerSettings *currentSettings;
@property (strong, nonatomic) NSMutableArray<WeakDelegateHolder*> *delegateHolders;
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
        self.delegateHolders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)applySettings:(LocationInputSwizzlerSettings *)settings {
    self.currentSettings = settings;
}

-(CLLocation*)locationSubstituteIfAny {
    if (!self.currentSettings) {
        return nil;
    }
    
    return [[CLLocation alloc] initWithLatitude:self.currentSettings.locationLatitude longitude:self.currentSettings.locationLongitude];
}

-(void)didAskToSetDelegate:(id<CLLocationManagerDelegate>)delegate onInstance:(CLLocationManager*)instance {
    
    instance.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    WeakDelegateHolder *newHolder = [[WeakDelegateHolder alloc] init];
    __weak WeakDelegateHolder *weakHolder = newHolder;
    
    newHolder.delegate = delegate;
    newHolder.whenDelegateSetToNil = ^{
        [weakSelf.delegateHolders removeObject:weakHolder];
    };
    
    [self.delegateHolders addObject:newHolder];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSArray *locationsForDelegates = nil;
    CLLocation *replacedLocation = [self locationSubstituteIfAny];
    if (replacedLocation) {
        locationsForDelegates = @[replacedLocation];
    } else {
        locationsForDelegates = locations;
    }
    
    for (WeakDelegateHolder *delegateHolder in self.delegateHolders) {
        [delegateHolder.delegate locationManager:manager didUpdateLocations:locationsForDelegates];
    }
}

@end


@interface CLLocationManager(LocationInputSwizzler)
@end

@implementation CLLocationManager(LocationInputSwizzler)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")){
        [self jr_swizzleMethod:@selector(location) withMethod:@selector(ppLocSwizzling_location) error:nil];
        
        [self jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(ppLocSwizzling_setDelegate:) error:nil];
    }
}

-(void)ppLocSwizzling_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    if ([delegate isKindOfClass:[LocationInputSwizzler class]]) {
        [self ppLocSwizzling_setDelegate:delegate];
        return;
    }
    [[LocationInputSwizzler sharedInstance] didAskToSetDelegate:delegate onInstance:self];
}

-(CLLocation *)ppLocSwizzling_location {
    
    CLLocation *loc = [[LocationInputSwizzler sharedInstance] locationSubstituteIfAny];
    if (!loc) {
        return [self ppLocSwizzling_location];
    }
    return loc;
}

@end
