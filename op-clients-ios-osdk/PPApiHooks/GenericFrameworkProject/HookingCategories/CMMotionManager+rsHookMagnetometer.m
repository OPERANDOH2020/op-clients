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





@interface CMMotionManager(rsHook_Magnetometer)

@end

@implementation CMMotionManager(rsHook_Magnetometer)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
    }
}
-(void)rsHook_startMagnetometerUpdates{
    [self rsHook_startMagnetometerUpdates];
}



@end
