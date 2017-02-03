//
//  MagnetometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MagnetometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import "JRSwizzle.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>






@interface MagnetometerInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedInput *magnetoSensor;
@end



@implementation MagnetometerInputSupervisor



-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.document = document;
    self.delegate = delegate;
    self.magnetoSensor = [CommonUtils extractInputOfType: InputType.Magnetometer from:document.accessedInputs];
}




-(void)processMagnetometerStatus {
    OPMonitorViolationReport *report = nil;
    if ((report = [self checkUnspecifiedAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)checkUnspecifiedAccess {
    if (self.magnetoSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app uses the magnetometer sensor without specifying in the self-compliance document" violationType:TypeUnregisteredSensorAccessed];
}

@end
