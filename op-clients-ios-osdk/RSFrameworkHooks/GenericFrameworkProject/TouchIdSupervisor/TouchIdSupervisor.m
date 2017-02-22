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
    NSDictionary *details = @{kInputTypeReportKey: InputType.TouchID};
    return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:TypeUnregisteredSensorAccessed];
}

@end
