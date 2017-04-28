//
//  CMAltimeter+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "NSObject+AutoSwizzle.h"
#import "PPEventDispatcher+Internal.h"

@interface CMAltimeter(rsHook_Altimeter)

@end

@implementation CMAltimeter(rsHook_Altimeter)

+(void)load{
    if (NSClassFromString(@"CMAltimeter")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}

HOOKEDClassMethod(BOOL, isRelativeAltitudeAvailable){
    BOOL result = CALL_ORIGINAL_METHOD(self, isRelativeAltitudeAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterGetRelativeAltitudeAvailableValue) atKey:kPPAltimeterIsRelativeAltitudeVailableValue];
}


HOOKEDInstanceMethod(void, startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler) {
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPAltimeterUpdatesQueue, queue)
    SAFEADD(evData, kPPAltimeterUpdatesHandler, handler)
    
    __Weak(self);
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakself, startRelativeAltitudeUpdatesToQueue: weakevData[kPPAltimeterUpdatesQueue] withHandler: weakevData[kPPAltimeterUpdatesHandler]);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterStartRelativeAltitudeUpdates) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

@end
