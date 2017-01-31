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

typedef void(^PedometerCallback)(NSDictionary*);
PedometerCallback _globalPedometerCallback;


@interface CMPedometer(rsHook)

@end


@implementation CMPedometer(rsHook)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self jr_swizzleMethod:@selector(startPedometerUpdatesFromDate:withHandler:) withMethod:@selector(rsHook_startPedometerUpdatesFromDate:withHandler:) error:nil];
    }
    
}

-(void)rsHook_startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler {
    SAFECALL(_globalPedometerCallback, nil);
    [self rsHook_startPedometerUpdatesFromDate:start withHandler:handler];
}

@end


@interface PedometerInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (weak, nonatomic) AccessedSensor *pedoSensor;

@end

@implementation PedometerInputSupervisor


-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.delegate = delegate;
    self.document = document;
    self.pedoSensor = [CommonUtils extractSensorOfType:SensorType.Pedometer from:document.accessedSensors];
    
    __weak typeof(self) weakSelf = self;
    _globalPedometerCallback = ^void(NSDictionary* status) {
        [weakSelf processPedometerStatus:status];
    };
}

-(void)processPedometerStatus:(NSDictionary*)statusDict {
    
    OPMonitorViolationReport *report = nil;
    if ((report = [self checkUnspecifiedAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)checkUnspecifiedAccess {
    if (self.pedoSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app accesses the pedometer sensor even though it is not specified in the self compliance document" violationType:TypeUnregisteredSensorAccessed];
}

@end
