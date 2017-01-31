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


typedef void(^MagnetometerCallback)(NSDictionary*);
MagnetometerCallback _globalMagnetometerCallback;



@interface CMMotionManager(rsHook_Magnetometer)

@end

@implementation CMMotionManager(rsHook_Magnetometer)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
    }
}
-(void)rsHook_startMagnetometerUpdates{
    SAFECALL(_globalMagnetometerCallback, nil)
    [self rsHook_startMagnetometerUpdates];
}

@end



@interface MagnetometerInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedSensor *magnetoSensor;
@end



@implementation MagnetometerInputSupervisor



-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.document = document;
    self.delegate = delegate;
    self.magnetoSensor = [CommonUtils extractSensorOfType:SensorType.Magnetometer from:document.accessedSensors];
    
    __weak typeof(self) weakSelf = self;
    
    _globalMagnetometerCallback = ^void(NSDictionary* status){
        [weakSelf processMagnetometerStatus:status];
    };
}




-(void)processMagnetometerStatus:(NSDictionary*)dict {
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
