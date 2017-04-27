//
//  LAContext+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "JRSwizzle.h"
#import "NSObject+AutoSwizzle.h"
#import "PPEventDispatcher+Internal.h"

@interface LAContext(rs_Hook)

@end

@implementation LAContext(rs_Hook)

+(void)load {
    if (NSClassFromString(@"LAContext")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}

HOOKEDInstanceMethod(BOOL, canEvaluatePolicy:(LAPolicy)policy error:(NSError * _Nullable __autoreleasing *)error){
    
    NSError *actualError = nil;
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, canEvaluatePolicy:policy error:&actualError);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    SAFEADD(dict, kPPContextErrorValue, actualError)
    dict[kPPContextPolicyValue] = @(policy);
    dict[kPPContextCanEvaluateContextPolicyValue] = @(actualValue);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLAContextEvent, EventContextCanEvaluatePolicy) eventData:dict whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    *error = dict[kPPContextErrorValue];
    return [dict[kPPContextCanEvaluateContextPolicyValue] boolValue];
}

HOOKEDInstanceMethod(void, evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void (^)(BOOL, NSError * _Nullable))reply) {
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPContextPolicyValue] = @(policy);
    evData[kPPContextBOOLErrorReplyBlock] = reply;
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, evaluatePolicy:policy localizedReason:localizedReason reply: reply);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLAContextEvent, EventContextEvaluatePolicy) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, evaluateAccessControl:(SecAccessControlRef)accessControl operation:(LAAccessControlOperation)operation localizedReason:(NSString *)localizedReason reply:(void (^)(BOOL, NSError * _Nullable))reply) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPContextBOOLErrorReplyBlock] = reply;
    evData[kPPContextSecAccessControlRefValue] = [NSValue valueWithPointer:accessControl];
    evData[kPPContextAccessControlOperationValue] = @(operation);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, evaluateAccessControl: accessControl operation: operation localizedReason: localizedReason reply: reply);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLAContextEvent, EventContextEvaluateAccessControlForOperation) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}


@end
