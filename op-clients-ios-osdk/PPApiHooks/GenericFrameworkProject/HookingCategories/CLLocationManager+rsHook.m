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
#import "PPEventsPipelineFactory.h"

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
    
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventLocationManagerStartLocationUpdates executionBlock:^{
        [weakSelf rsHook_startUpdatingLocation];
    } executionBlockKey:kPPStartLocationUpdatesConfirmation];
}

-(void)rsHook_requestAlwaysAuthorization {
    
    __weak typeof(self) weakSelf = self;
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventLocationManagerRequestAlwaysAuthorization executionBlock:^{
        [weakSelf rsHook_requestWhenInUseAuthorization];
    } executionBlockKey:kPPRequestAlwaysAuthorizationConfirmation];
}


-(void)rsHook_requestWhenInUseAuthorization {
    
    __weak typeof(self) weakSelf = self;
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventLocationManagerRequestWhenInUseAuthorization executionBlock:^{
        [weakSelf rsHook_requestWhenInUseAuthorization];
    } executionBlockKey:kPPRequestWhenInUseAuthorizationConfirmation];
}


-(void)rsHook_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    if (!delegate) {
        [self rsHook_setDelegate:delegate];
        return;
    }
    
    NSMutableDictionary *evData = [@{} mutableCopy];
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock setDelegateConfirmation = ^{
        id possiblyModifiedDelegate = evData[kPPLocationManagerDelegate];
        if (![possiblyModifiedDelegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
            return;
        }
        [weakSelf rsHook_setDelegate:possiblyModifiedDelegate];
    };
    
    [evData addEntriesFromDictionary:@{ kPPLocationManagerDelegate: delegate,
                                        kPPLocationManagerInstance: self,
                                        kPPLocationManagerSetDelegateConfirmation: setDelegateConfirmation
                                       }];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventLocationManagerSetDelegate eventData:evData whenNoHandlerAvailable:setDelegateConfirmation];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
}

-(CLLocation *)rsHook_location {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    CLLocation *actualLocation = [self rsHook_location];
    if (actualLocation) {
        [evData setObject:actualLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    }
    
    [evData setObject:self forKey:kPPLocationManagerInstance];
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventLocationManagerGetCurrentLocation eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    CLLocation *possiblyModifiedLocation = evData[kPPLocationManagerGetCurrentLocationValue];
    
    if (!(possiblyModifiedLocation && [possiblyModifiedLocation isKindOfClass:[CLLocation class]])) {
        return nil;
    }
    
    return possiblyModifiedLocation;
}



@end
