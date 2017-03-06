//
//  PedometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PedometerInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"



@interface PedometerInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (weak, nonatomic) AccessedInput *pedoSensor;

@end

@implementation PedometerInputSupervisor


-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.delegate = delegate;
    self.document = document;
    self.pedoSensor = [CommonUtils extractInputOfType: InputType.Pedometer from:document.accessedInputs];
}

-(void)processPedometerStatus {
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.pedoSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Pedometer dateReported:[NSDate date]];
}

@end
