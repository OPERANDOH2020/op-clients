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
    
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventMotionManagerStartMagnetometerUpdates executionBlock:^{
        [weakSelf rsHook_startMagnetometerUpdates];
    } executionBlockKey:kPPStartMagnetometerUpdatesConfirmation];
}

-(void)rsHook_startAccelerometerUpdates {
    __weak typeof(self) weakSelf = self;
    
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventMotionManagerStartAccelerometerUpdates executionBlock:^{
        [weakSelf rsHook_startAccelerometerUpdates];
    } executionBlockKey:kPPStartAccelerometerUpdatesConfirmation];
}


-(void)rsHook_startDeviceMotionUpdates {
    __weak typeof(self) weakSelf = self;
    [[PPEventsPipelineFactory eventsDispatcher] fireSafeEventForType:EventMotionManagerStartDeviceMotionUpdates executionBlock:^{
        [weakSelf rsHook_startDeviceMotionUpdates];
    } executionBlockKey:kPPStartDeviceMotionUpdatesConfirmation];
}



@end
