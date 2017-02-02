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


typedef void(^AltimeterCallback)();
AltimeterCallback _globalAltimeterCallback;


@interface CMAltimeter(rsHook_Altimeter)

@end

@implementation CMAltimeter(rsHook_Altimeter)


-(void)rsHook_startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler {
    
    SAFECALL(_globalAltimeterCallback);
    [self rsHook_startRelativeAltitudeUpdatesToQueue:queue withHandler:handler];
    
}

@end

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
    
    __weak typeof(self) weakSelf = self;
    _globalAltimeterCallback = ^void(){
        [weakSelf processAltimeterStatus];
    };
}

-(void)processAltimeterStatus {
    OPMonitorViolationReport *report = nil;
    if ((report = [self checkUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)checkUnregisteredAccess {
    if (self.sensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The barometer sensor is accessed without being specified in the SCD" violationType:TypeUnregisteredSensorAccessed];
}

@end
