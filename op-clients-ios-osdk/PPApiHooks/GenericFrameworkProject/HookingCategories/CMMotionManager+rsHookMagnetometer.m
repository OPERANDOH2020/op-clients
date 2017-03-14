//
//  CMMotionManager+rsHookMagnetometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "PPEventDispatcher+Internal.h"
#import "PPEventsPipelineFactory.h"


@interface CMMotionManager(rsHookUpdates)
@end

@implementation CMMotionManager(rsHookUpdates)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
    }
}

-(void)rsHook_startMagnetometerUpdates{
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock confirmation = ^{
        [weakSelf rsHook_startMagnetometerUpdates];
    };
    
    NSMutableDictionary *evData = [@{
                                     kPPStartMagnetometerUpdatesConfirmation: confirmation
                                     }
                                   mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventMotionManagerStartMagnetometerUpdates eventData:evData];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
}

-(void)rsHook_startAccelerometerUpdates {
    __weak typeof(self) weakSelf = self;
    PPVoidBlock confirmation = ^{
        [weakSelf rsHook_startAccelerometerUpdates];
    };
    
    NSMutableDictionary *evData = [@{
                                     kPPStartAccelerometerUpdatesConfirmation: confirmation
                                     }
                                   mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventMotionManagerStartAccelerometerUpdates eventData:evData];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
}


-(void)rsHook_startDeviceMotionUpdates {
    
}

@end
