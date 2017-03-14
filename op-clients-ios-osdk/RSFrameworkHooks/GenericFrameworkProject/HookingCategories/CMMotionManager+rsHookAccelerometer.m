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



@interface PPFakeDeviceMotion : CMDeviceMotion
@property (assign, nonatomic) CMAcceleration fakeUserAcceleration;
@property (assign, nonatomic) CMRotationRate fakeRotationRate;
@property (assign, nonatomic) CMAcceleration fakeGravity;
@end


@implementation PPFakeDeviceMotion

-(CMAcceleration)userAcceleration {
    return self.fakeUserAcceleration;
}

-(CMRotationRate)rotationRate {
    return self.fakeRotationRate;
}

-(CMAcceleration)gravity {
    return self.fakeGravity;
}

@end

@interface CMMotionManager(rsHook_Accelerometer)

@end


@implementation CMMotionManager(rsHook_Accelerometer)

+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startDeviceMotionUpdatesToQueue:withHandler:) withMethod:@selector(rsHook_startDeviceMotionUpdatesToQueue:withHandler:) error:nil];
    }
}

-(void)rsHook_startAccelerometerUpdates{
    [[CMMotionManager accelerometerInputSupervisor] processAccelerometerStatus];
    [self rsHook_startAccelerometerUpdates];
}

-(CMDeviceMotion *)deviceMotion {
    return [[PPFakeDeviceMotion alloc] init];
}

-(void)rsHook_startDeviceMotionUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMDeviceMotionHandler)handler {
    
    CMDeviceMotion *dm = [[PPFakeDeviceMotion alloc] init];
    
    for (int i=1; i<=50; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [queue addOperationWithBlock:^{
               SAFECALL(handler, dm, nil)
            }];
        });
    }
    
}

+(AccelerometerInputSupervisor*)accelerometerInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[AccelerometerInputSupervisor class]];
}

@end
