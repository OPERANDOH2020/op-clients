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
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedInput *proximitySensor;
@end

@implementation ProximityInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.delegate = delegate;
    self.document = document;
    self.proximitySensor = [CommonUtils extractInputOfType: InputType.Proximity from:document.accessedInputs];
    
}


-(void)processProximitySensorAccess {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}

-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.proximitySensor) {
        return nil;
    }
    NSDictionary *details = @{kInputTypeReportKey: InputType.Proximity};
    return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:TypeUnregisteredSensorAccessed];
}

@end
