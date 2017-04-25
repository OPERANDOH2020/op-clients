//
//  CLLocationManager+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "JRSwizzle.h"
#import "PPEventDispatcher+Internal.h"
#import "PPEvent.h"

@interface CLLocationManager(Hook)

@end


@implementation CLLocationManager(Hook)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self jr_swizzleMethod:@selector(startUpdatingLocation) withMethod:@selector(rsHook_startUpdatingLocation) error:nil];
        
        [self jr_swizzleMethod:@selector(requestAlwaysAuthorization) withMethod:@selector(rsHook_requestAlwaysAuthorization) error:nil];
        
        [self jr_swizzleMethod:@selector(requestWhenInUseAuthorization) withMethod:@selector(rsHook_requestWhenInUseAuthorization) error:nil];
        
        [self jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(rsHook_setDelegate:) error:nil];
        
        [self jr_swizzleMethod:@selector(location) withMethod:@selector(rsHook_location) error:nil];
        
    }
}

-(void)rsHook_startUpdatingLocation {
    
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerStartLocationUpdates) executionBlock:^{
        [weakSelf rsHook_startUpdatingLocation];
    } executionBlockKey:kConfirmationCallbackBlock];
}

-(void)rsHook_requestAlwaysAuthorization {
    
    __weak typeof(self) weakSelf = self;
    PPEventIdentifier identifier = PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestAlwaysAuthorization);
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:identifier executionBlock:^{
        [weakSelf rsHook_requestWhenInUseAuthorization];
    } executionBlockKey:kConfirmationCallbackBlock];
}


-(void)rsHook_requestWhenInUseAuthorization {
    
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution: PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestWhenInUseAuthorization) executionBlock:^{
        [weakSelf rsHook_requestWhenInUseAuthorization];
    } executionBlockKey:kConfirmationCallbackBlock];
}


-(void)rsHook_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    if (!delegate) {
        [self rsHook_setDelegate:delegate];
        return;
    }
    
    NSMutableDictionary *evData = [@{} mutableCopy];
    __weak NSMutableDictionary *weakEvData = evData;
    
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock setDelegateConfirmation = ^{
        id possiblyModifiedDelegate = weakEvData[kPPLocationManagerDelegate];
        if (![possiblyModifiedDelegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
            return;
        }
        [weakSelf rsHook_setDelegate:possiblyModifiedDelegate];
    };
    
    [evData addEntriesFromDictionary:@{ kPPLocationManagerDelegate: delegate,
                                        kPPLocationManagerInstance: self,
                                        kPPLocationManagerSetDelegateConfirmation: setDelegateConfirmation
                                       }];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerSetDelegate) eventData:evData whenNoHandlerAvailable:setDelegateConfirmation];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

-(CLLocation *)rsHook_location {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    CLLocation *actualLocation = [self rsHook_location];
    if (actualLocation) {
        [evData setObject:actualLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    }
    
    [evData setObject:self forKey:kPPLocationManagerInstance];
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerGetCurrentLocation) eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    CLLocation *possiblyModifiedLocation = evData[kPPLocationManagerGetCurrentLocationValue];
    
    if (!(possiblyModifiedLocation && [possiblyModifiedLocation isKindOfClass:[CLLocation class]])) {
        return nil;
    }
    
    return possiblyModifiedLocation;
}



@end
