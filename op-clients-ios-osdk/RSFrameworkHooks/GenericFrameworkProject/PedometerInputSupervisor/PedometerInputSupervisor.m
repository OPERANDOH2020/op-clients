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
@property (strong, nonatomic) InputSupervisorModel *model;
@property (weak, nonatomic) AccessedInput *pedoSensor;

@end

@implementation PedometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.pedoSensor = [CommonUtils extractInputOfType: InputType.Pedometer from:model.scdDocument.accessedInputs];
    
}


-(void)processPedometerStatus {
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.pedoSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Pedometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
