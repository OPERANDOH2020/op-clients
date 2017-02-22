//
//  CameraInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CameraInputSupervisor.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "CommonUtils.h"
#import "JRSwizzle.h"



@interface CameraInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *cameraSensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation CameraInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.document = document;
    self.delegate = delegate;
    self.cameraSensor = [CommonUtils extractInputOfType: InputType.Camera from:document.accessedInputs];
    
}

-(void)processCameraAccess {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}

-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.cameraSensor) {
        return nil;
    }
    
    NSDictionary *details = @{kInputTypeReportKey: InputType.Camera};
    return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:TypeUnregisteredSensorAccessed];
}

@end
