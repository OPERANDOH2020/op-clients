//
//  BarometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BarometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>


@interface BarometerInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *sensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation BarometerInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    self.document = document;
    self.delegate = delegate;
    self.sensor = [CommonUtils extractInputOfType:InputType.Barometer from:document.accessedInputs];
    
}

-(void)processAltimeterStatus {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.sensor) {
        return nil;
    }
    
    
    NSDictionary *details = @{kInputTypeReportKey: InputType.Barometer};
    return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:TypeUnregisteredSensorAccessed];
}

@end
