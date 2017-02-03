//
//  CMPedometer+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PedometerInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"
#import "InputSupervisorsManager.h"



@interface CMPedometer(rsHook)

@end


@implementation CMPedometer(rsHook)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self jr_swizzleMethod:@selector(startPedometerUpdatesFromDate:withHandler:) withMethod:@selector(rsHook_startPedometerUpdatesFromDate:withHandler:) error:nil];
    }
    
}

-(void)rsHook_startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler {
    [[CMPedometer pedometerInputSupervisor] processPedometerStatus];
    [self rsHook_startPedometerUpdatesFromDate:start withHandler:handler];
}


+(PedometerInputSupervisor*)pedometerInputSupervisor {
    return [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[PedometerInputSupervisor class]];
}

@end
