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
        
    }
}

-(void)rsHook_startUpdatingLocation {
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock confirmation = ^{
        [weakSelf rsHook_startUpdatingLocation];
    };
    
    NSMutableDictionary *eventData = [@{
                                        kPPStartLocationUpdatesConfirmation: confirmation
                                       } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventLocationManagerStartLocationUpdates eventData:eventData];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
}

-(void)rsHook_requestAlwaysAuthorization {
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock confirmation = ^{
        [weakSelf rsHook_requestAlwaysAuthorization];
    };
    NSMutableDictionary *dict = [@{
                                   kPPRequestAlwaysAuthorizationConfirmation: confirmation
                                   } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventLocationManagerRequestAlwaysAuthorization eventData:dict];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
}


-(void)rsHook_requestWhenInUseAuthorization {
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock confirmation =  ^{
        [weakSelf rsHook_requestWhenInUseAuthorization];
    };
    
    NSMutableDictionary *dict = [@{
                                   kPPRequestWhenInUseAuthorizationConfirmation: confirmation
                                   } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventLocationManagerRequestWhenInUseAuthorization eventData:dict];
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent: event];
}


@end
