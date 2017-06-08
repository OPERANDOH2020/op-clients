//
//  CMAltimeter+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CMAltimeter+PPHOOK.h"
#import "AuthenticationKeyGenerator.h"

PPEventDispatcher *_altDispatcher;

@implementation CMAltimeter(PPHOOK)

+(void)load{
    if (NSClassFromString(@"CMAltimeter")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _altDispatcher = dispatcher;
}

HOOKPrefixClass(BOOL, isRelativeAltitudeAvailable){
    BOOL result = CALL_PREFIXED(self, isRelativeAltitudeAvailable);
    
    __block BOOL value = NO;
    
    apiHooksCore_withSafelyManagedKey(^void(char *authenticationKey){
        value =  [_altDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterGetRelativeAltitudeAvailableValue) atKey:kPPAltimeterIsRelativeAltitudeVailableValue authentication:authenticationKey];
    });
    
    return value;
}


HOOKPrefixInstance(void, startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler) {
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPAltimeterUpdatesQueue, queue)
    SAFEADD(evData, kPPAltimeterUpdatesHandler, handler)
    
    __Weak(self);
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakself, startRelativeAltitudeUpdatesToQueue: weakevData[kPPAltimeterUpdatesQueue] withHandler: weakevData[kPPAltimeterUpdatesHandler]);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterStartRelativeAltitudeUpdates) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    apiHooksCore_withSafelyManagedKey(^void(char *authenticationKey){
        [_altDispatcher fireEvent:event authentication:authenticationKey];
    });
}

@end
