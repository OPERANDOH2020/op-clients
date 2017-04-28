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
#import "NSObject+AutoSwizzle.h"

@interface CMPedometer(rsHook)

@end


@implementation CMPedometer(rsHook)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
    
}

HOOKEDClassMethod(BOOL, isStepCountingAvailable){
    BOOL result = CALL_ORIGINAL_METHOD(self, isStepCountingAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetStepCountingAvailable) atKey:kPPPedometerIsStepCountingAvailableValue];
}

HOOKEDClassMethod(BOOL, isDistanceAvailable){
    BOOL result = CALL_ORIGINAL_METHOD(self, isDistanceAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetDistanceAvailable) atKey:kPPPedometerIsDistanceAvailableValue];
}

HOOKEDClassMethod(BOOL, isFloorCountingAvailable) {
    BOOL result = CALL_ORIGINAL_METHOD(self, isFloorCountingAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetFloorCountingAvailable) atKey:kPPPedometerIsFloorCountingAvailableValue];
}

HOOKEDClassMethod(BOOL, isPaceAvailable){
    BOOL paceAv = CALL_ORIGINAL_METHOD(self, isPaceAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:paceAv ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetPaceAvailable) atKey:kPPPedometerIsPaceAvailableValue];
}


HOOKEDClassMethod(BOOL, isCadenceAvailable){
    BOOL result = CALL_ORIGINAL_METHOD(self, isCadenceAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetCadenceAvailable) atKey:kPPPedometerIsCadenceAvailableValue];
}

HOOKEDClassMethod(BOOL, isPedometerEventTrackingAvailable){
    BOOL result = CALL_ORIGINAL_METHOD(self, isPedometerEventTrackingAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetEventTrackingAvailable) atKey:kPPPedometerIsEventTrackingAvailableValue];
}

HOOKEDInstanceMethod(void, queryPedometerDataFromDate:(NSDate *)start toDate:(NSDate *)end withHandler:(CMPedometerHandler)handler){
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPedometerStartDateValue, start)
    SAFEADD(evData, kPPPedometerEndDateValue, end)
    SAFEADD(evData, kPPPedometerHandlerValue, handler)
    
    __Weak(evData);
    __Weak(self);
    PPVoidBlock confirmationOrDefault = ^{
        NSDate *evStartDate = weakevData[kPPPedometerStartDateValue];
        NSDate *evEndDate = weakevData[kPPPedometerEndDateValue];
        CMPedometerHandler evHandler = weakevData[kPPPedometerHandlerValue];
        CALL_ORIGINAL_METHOD(weakself, queryPedometerDataFromDate:evStartDate toDate:evEndDate withHandler:evHandler);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerQueryDataFromDate) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
}

HOOKEDInstanceMethod(void, startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    __weak NSMutableDictionary *weakData = evData;
    
    SAFEADD(evData, kPPPedometerUpdatesDateValue, start)
    SAFEADD(evData, kPPPedometerHandlerValue, handler)
    PPVoidBlock confirmation = ^{
        NSDate *possiblyModifiedDate = weakData[kPPPedometerUpdatesDateValue];
        CMPedometerHandler possiblyModifiedHandler = weakData[kPPPedometerHandlerValue];
        if (!(possiblyModifiedDate && possiblyModifiedHandler)) {
            return;
        }
        
        CALL_ORIGINAL_METHOD(weakSelf, startPedometerUpdatesFromDate:possiblyModifiedDate withHandler:possiblyModifiedHandler);
        
    };
    [evData setObject:confirmation forKey:kPPConfirmationCallbackBlock];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerStartUpdatesFromDate) eventData:evData whenNoHandlerAvailable:confirmation];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, startPedometerEventUpdatesWithHandler:(CMPedometerEventHandler)handler){
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPedometerEventUpdatesHandler, handler)
    __Weak(evData);
    __Weak(self);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakself, startPedometerEventUpdatesWithHandler:weakevData[kPPPedometerEventUpdatesHandler]);
    };
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerStartEventUpdatesWithHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}


@end
