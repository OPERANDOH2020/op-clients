//
//  CMPedometer+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"



@interface CMPedometer(rsHook)

@end


@implementation CMPedometer(rsHook)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self jr_swizzleMethod:@selector(startPedometerUpdatesFromDate:withHandler:) withMethod:@selector(rsHook_startPedometerUpdatesFromDate:withHandler:) error:nil];
    }
    
}

-(void)rsHook_startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler {
    [self rsHook_startPedometerUpdatesFromDate:start withHandler:handler];
}




@end
