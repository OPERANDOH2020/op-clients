//
//  CMMotionManager+rsHookAccelerometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"


@interface CMMotionManager(rsHook_Accelerometer)

@end


@implementation CMMotionManager(rsHook_Accelerometer)

+(void)load{
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
    }
}

-(void)rsHook_startAccelerometerUpdates{
    [self rsHook_startAccelerometerUpdates];
}


@end
