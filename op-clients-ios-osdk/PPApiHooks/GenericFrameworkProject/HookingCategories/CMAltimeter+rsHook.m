//
//  CMAltimeter+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

typedef void(^AltimeterCallback)();
AltimeterCallback _globalAltimeterCallback;


@interface CMAltimeter(rsHook_Altimeter)

@end

@implementation CMAltimeter(rsHook_Altimeter)


-(void)rsHook_startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler {
    
    [self rsHook_startRelativeAltitudeUpdatesToQueue:queue withHandler:handler];
    
}


@end
