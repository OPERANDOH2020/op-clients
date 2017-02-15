//
//  CMMotionManager+rsHookMagnetometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MagnetometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import "JRSwizzle.h"
#import "InputSupervisorsManager.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^MagnetometerCallback)();
MagnetometerCallback _globalMagnetometerCallback;



@interface CMMotionManager(rsHook_Magnetometer)

@end

@implementation CMMotionManager(rsHook_Magnetometer)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
    }
}
-(void)rsHook_startMagnetometerUpdates{
    [[CMMotionManager magnetometerInputSupervisor] processMagnetometerStatus];
    [self rsHook_startMagnetometerUpdates];
}

+(MagnetometerInputSupervisor*)magnetometerInputSupervisor {
    return [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[MagnetometerInputSupervisor class]];
}

@end
