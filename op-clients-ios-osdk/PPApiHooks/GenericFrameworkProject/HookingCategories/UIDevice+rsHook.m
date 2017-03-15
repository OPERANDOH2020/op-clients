//
//  UIDevice+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "PPEvent.h"
#import "PPEventsPipelineFactory.h"
#import "Common.h"
#import "PPEventDispatcher+Internal.h"

@interface UIDevice(rsHook)

@end

@implementation UIDevice(rsHook)

+(void)load{
    
    [self jr_swizzleMethod:@selector(setProximitySensingEnabled:) withMethod:@selector(rsHook_setProximitySensingEnabled:) error:nil];
    
    [self jr_swizzleMethod:@selector(setProximityMonitoringEnabled:) withMethod:@selector(rsHook_setProximityMonitoringEnabled:) error:nil];
    
    [self jr_swizzleClassMethod:@selector(proximityState) withClassMethod:@selector(rsHook_proximityState) error:nil];
}

-(void)rsHook_setProximityMonitoringEnabled:(BOOL)enabled {
    
    PPEventType eventType = EventSetDeviceProximityMonitoringEnabled;
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximityMonitoringEnabledValue: @(enabled)
                                     } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:eventType eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSNumber *possiblyModifiedValue = evData[kPPDeviceProximityMonitoringEnabledValue];
    if (!(possiblyModifiedValue && [possiblyModifiedValue isKindOfClass:[NSNumber class]])){
        return;
    }
    
    [self rsHook_setProximityMonitoringEnabled:[possiblyModifiedValue boolValue]];
}

-(void)rsHook_setProximitySensingEnabled:(BOOL)enabled {
    
    PPEventType eventType = EventSetDeviceProximitySensingEnabled;
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximitySensingEnabledValue: @(enabled)
                                     } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:eventType eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSNumber *possiblyModifiedValue = evData[kPPDeviceProximitySensingEnabledValue];
    if (!(possiblyModifiedValue && [possiblyModifiedValue isKindOfClass:[NSNumber class]])){
        return;
    }
    
    
    [self rsHook_setProximitySensingEnabled:[possiblyModifiedValue boolValue]];
}

-(BOOL)rsHook_proximityState {
    
    BOOL actualProximityState = [self rsHook_proximityState];
    NSMutableDictionary *dict = [@{kPPDeviceProxmityStateValue: @(actualProximityState)} mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventGetDeviceProximityState eventData:dict whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSNumber *possiblyModifiedValue = dict[kPPDeviceProxmityStateValue];
    if (!(possiblyModifiedValue && [possiblyModifiedValue isKindOfClass:[NSNumber class]])){
        return actualProximityState;
    }
    
    return [possiblyModifiedValue boolValue];
}



@end
