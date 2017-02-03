//
//  CMMotionManager+rsHookAccelerometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "AccelerometerInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"
#import "InputSupervisorsManager.h"


@interface CMMotionManager(rsHook_Accelerometer)

@end


@implementation CMMotionManager(rsHook_Accelerometer)

+(void)load{
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
    }
}

-(void)rsHook_startAccelerometerUpdates{
    [[CMMotionManager accelerometerInputSupervisor] processAccelerometerStatus];
    [self rsHook_startAccelerometerUpdates];
}

+(AccelerometerInputSupervisor*)accelerometerInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[AccelerometerInputSupervisor class]];
}

@end
