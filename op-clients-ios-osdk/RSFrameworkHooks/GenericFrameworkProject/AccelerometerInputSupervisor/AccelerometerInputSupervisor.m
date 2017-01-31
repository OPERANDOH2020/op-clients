//
//  AccelerometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "AccelerometerInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"

typedef void(^AccelerometerCallback)(NSDictionary*);
AccelerometerCallback _globalAccelerometerCallback;

@interface CMMotionManager(rsHook_Accelerometer)

@end


@implementation CMMotionManager(rsHook_Accelerometer)

+(void)load{
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
    }
}

-(void)rsHook_startAccelerometerUpdates{
    SAFECALL(_globalAccelerometerCallback, nil)
    [self rsHook_startAccelerometerUpdates];
}

@end





@interface AccelerometerInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedSensor *accSensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end


@implementation AccelerometerInputSupervisor


-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.delegate = delegate;
    self.document = document;
    self.accSensor = [CommonUtils extractSensorOfType:SensorType.Accelerometer from:document.accessedSensors];
    
}


-(void)processAccelerometerStatus:(NSDictionary*)statusDict {
    OPMonitorViolationReport *report = nil;
    if ((report = [self checkUnspecifiedAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)checkUnspecifiedAccess{
    if (self.accSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app uses the accelerometer sensor without having specified in the self-compliance document!" violationType:TypeUnregisteredSensorAccessed];
}

@end
