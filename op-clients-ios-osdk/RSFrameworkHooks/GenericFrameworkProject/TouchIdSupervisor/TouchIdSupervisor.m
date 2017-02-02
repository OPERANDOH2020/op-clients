//
//  TouchIdSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "TouchIdSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
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
        SAFECALL(_globalTouchIdCallback)
    }
    
    [self rsHook_evaluatePolicy:policy localizedReason:localizedReason reply:reply];
    
}


@end


@interface TouchIdSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedInput *accessedSensor;

@end

@implementation TouchIdSupervisor



-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.document = document;
    self.delegate = delegate;
    self.accessedSensor = [CommonUtils extractInputOfType: InputType.TouchID from:document.accessedInputs];
    
    __weak typeof(self) weakSelf = self;
    _globalTouchIdCallback = ^void() {
        [weakSelf processTouchIDUsage];
    };
}

-(void)processTouchIDUsage{
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}

-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.accessedSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app accesses the TouchID API even though it is not specified in the self-compliance document!" violationType:TypeUnregisteredSensorAccessed];
}

@end
