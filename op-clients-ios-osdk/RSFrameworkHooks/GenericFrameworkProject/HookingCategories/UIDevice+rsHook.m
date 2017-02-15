//
//  UIDevice+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ProximityInputSupervisor.h"
#import "InputSupervisorsManager.h"
#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "Common.h"
#import "CommonUtils.h"


@interface UIDevice(rsHook)

@end

@implementation UIDevice(rsHook)

+(void)load{
    
    [self jr_swizzleMethod:@selector(setProximitySensingEnabled:) withMethod:@selector(rsHook_setProximitySensingEnabled:) error:nil];
    
    [self jr_swizzleMethod:@selector(setProximityMonitoringEnabled:) withMethod:@selector(rsHook_setProximityMonitoringEnabled:) error:nil];
}

-(void)rsHook_setProximityMonitoringEnabled:(BOOL)enabled {
    [[UIDevice proximityInputSupervisor] processProximitySensorAccess];
    [self rsHook_setProximityMonitoringEnabled:enabled];
}

-(void)rsHook_setProximitySensingEnabled:(BOOL)enabled {
    [[UIDevice proximityInputSupervisor] processProximitySensorAccess];
    [self rsHook_setProximitySensingEnabled:enabled];
}

+(ProximityInputSupervisor*)proximityInputSupervisor {
    return [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[ProximityInputSupervisor class]];
}

@end
