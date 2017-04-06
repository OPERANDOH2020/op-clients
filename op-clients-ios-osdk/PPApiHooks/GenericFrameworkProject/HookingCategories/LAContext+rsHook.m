//
//  LAContext+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "JRSwizzle.h"

typedef void(^TouchIdCallback)();
TouchIdCallback _globalTouchIdCallback;

@interface LAContext(rs_Hook)

@end

@implementation LAContext(rs_Hook)

+(void)load {
    if (NSClassFromString(@"LAContext")) {
        [self jr_swizzleMethod:@selector(evaluatePolicy:localizedReason:reply:) withMethod:@selector(rsHook_evaluatePolicy:localizedReason:reply:) error:nil];
    }
}

-(void)rsHook_evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void (^)(BOOL, NSError * _Nullable))reply {
    
    if (policy == LAPolicyDeviceOwnerAuthenticationWithBiometrics) {
    }
    
    [self rsHook_evaluatePolicy:policy localizedReason:localizedReason reply:reply];
    
}


@end
