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

typedef void(^ProximityCallback)();

ProximityCallback _globalProximityCallback;

@interface UIDevice(rsHook)

@end

@implementation UIDevice(rsHook)

+(void)load{
    
    [self jr_swizzleMethod:@selector(setProximitySensingEnabled:) withMethod:@selector(rsHook_setProximitySensingEnabled:) error:nil];
    
    [self jr_swizzleMethod:@selector(setProximityMonitoringEnabled:) withMethod:@selector(rsHook_setProximityMonitoringEnabled:) error:nil];
}

-(void)rsHook_setProximityMonitoringEnabled:(BOOL)enabled {
    SAFECALL(_globalProximityCallback, nil)
    [self rsHook_setProximityMonitoringEnabled:enabled];
}

-(void)rsHook_setProximitySensingEnabled:(BOOL)enabled {
    SAFECALL(_globalProximityCallback, nil)
    [self rsHook_setProximitySensingEnabled:enabled];
}

@end

@interface ProximityInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedSensor *proximitySensor;
@end

@implementation ProximityInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.delegate = delegate;
    self.document = document;
    self.proximitySensor = [CommonUtils extractSensorOfType:SensorType.Proximity from:document.accessedSensors];
    
    __weak typeof(self) weakSelf = self;
    _globalProximityCallback = ^void(NSDictionary* dict){
        [weakSelf processMonitoringSensorEnabled:NO];
        // must continue implementation later
    };
}

-(void)processMonitoringSensorEnabled:(BOOL)enabled {
    if (self.proximitySensor) {
        return;
    }
    
    [self.delegate newViolationReported:[[OPMonitorViolationReport alloc] initWithDetails:@"The app uses the proxmity sensor even though it is not specified in the self compliance document!" violationType:TypeUnregisteredSensorAccessed]];
}


@end
