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
    
    CALL_ORIGINAL_METHOD(self, evaluatePolicy:policy localizedReason:localizedReason reply:reply);
}




@end
