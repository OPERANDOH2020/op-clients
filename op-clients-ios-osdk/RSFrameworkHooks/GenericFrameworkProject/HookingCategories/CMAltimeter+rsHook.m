//
//  CMAltimeter+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BarometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>
#import "InputSupervisorsManager.h"

typedef void(^AltimeterCallback)();
AltimeterCallback _globalAltimeterCallback;


@interface CMAltimeter(rsHook_Altimeter)

@end

@implementation CMAltimeter(rsHook_Altimeter)


-(void)rsHook_startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler {
    
    [[CMAltimeter barometerInputSupervisor] processAltimeterStatus];
    [self rsHook_startRelativeAltitudeUpdatesToQueue:queue withHandler:handler];
    
}

+(BarometerInputSupervisor*)barometerInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[BarometerInputSupervisor class]];
}

@end
