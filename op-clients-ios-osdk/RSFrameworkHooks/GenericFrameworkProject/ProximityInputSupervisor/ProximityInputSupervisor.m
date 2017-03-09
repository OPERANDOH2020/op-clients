//
//  ProximityInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ProximityInputSupervisor.h"
#import "CommonUtils.h"

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "Common.h"

@interface ProximityInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *proximitySensor;
@end

@implementation ProximityInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.proximitySensor = [CommonUtils extractInputOfType: InputType.Proximity from:model.scdDocument.accessedInputs];
    
}

-(void)processProximitySensorAccess {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.proximitySensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Proximity dateReported:[NSDate date]];
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}

@end
