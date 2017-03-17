//
//  CMPedometer+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"
#import "Common.h"
#import "PPEventDispatcher+Internal.h"
#import "PPEventsPipelineFactory.h"


@interface CMPedometer(rsHook)

@end


@implementation CMPedometer(rsHook)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self jr_swizzleMethod:@selector(startPedometerUpdatesFromDate:withHandler:) withMethod:@selector(rsHook_startPedometerUpdatesFromDate:withHandler:) error:nil];
    }
    
}

-(void)rsHook_startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    __weak NSMutableDictionary *weakData = evData;
    
    SAFEADD(evData, kPPPedometerUpdatesDateValue, start)
    SAFEADD(evData, kPPPedometerUpdatesHandler, handler)
    PPVoidBlock confirmation = ^{
        NSDate *possiblyModifiedDate = weakData[kPPPedometerUpdatesDateValue];
        CMPedometerHandler possiblyModifiedHandler = weakData[kPPPedometerUpdatesHandler];
        if (!(possiblyModifiedDate && possiblyModifiedHandler)) {
            return;
        }
        
        [weakSelf rsHook_startPedometerUpdatesFromDate:possiblyModifiedDate withHandler:possiblyModifiedHandler];
        
    };
    [evData setObject:confirmation forKey:kPPStartPedometerUpdatesConfirmation];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventStartPedometerUpdates eventData:evData whenNoHandlerAvailable:confirmation];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
}




@end
