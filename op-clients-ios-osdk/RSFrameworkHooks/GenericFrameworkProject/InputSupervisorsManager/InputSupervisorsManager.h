//
//  InputSupervisorsManager.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

#import "ContactsInputSupervisor.h"
#import "MicrophoneInputSupervisor.h"
#import "MagnetometerInputSupervisor.h"
#import "CameraInputSupervisor.h"
#import "TouchIdSupervisor.h"
#import "BarometerInputSupervisor.h"
#import "AccelerometerInputSupervisor.h"
#import "ProximityInputSupervisor.h"
#import "PedometerInputSupervisor.h"
#import "LocationInputSupervisor.h"
#import "NSURLSessionSupervisor.h"


@interface InputSupervisorsManager : NSObject

//These methods are intended to be called by the class categories which implement the swizzling
+(InputSupervisorsManager*)sharedInstance;
-(id)inputSupervisorOfType:(Class)type;



//These methods are intended to be called by the monitor API

+(void)buildSharedInstanceWithSupervisors:(NSArray<id<InputSourceSupervisor>>*)supervisors;

@end
