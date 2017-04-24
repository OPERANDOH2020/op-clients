//
//  CMMotionManager+rsHookMagnetometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "PPEventDispatcher+Internal.h"


@interface CMMotionManager(rsHookUpdates)
@end

@implementation CMMotionManager(rsHookUpdates)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
    }
}

-(void)rsHook_startMagnetometerUpdates{
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdates) executionBlock:^{
        [weakSelf rsHook_startMagnetometerUpdates];
    } executionBlockKey:kPPStartMagnetometerUpdatesConfirmation];
}

-(void)rsHook_startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerAccelerometerHandler, handler);
    
    PPVoidBlock confirmation = ^{
        NSOperationQueue *opQueue = evData[kPPMotionManagerUpdatesQueue];
        CMAccelerometerHandler accHandler = evData[kPPMotionManagerAccelerometerHandler];
        [weakSelf rsHook_startAccelerometerUpdatesToQueue:opQueue withHandler:accHandler];
    };
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmation];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

-(void)rsHook_startAccelerometerUpdates {
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdates) executionBlock:^{
        [weakSelf rsHook_startAccelerometerUpdates];
    } executionBlockKey:kPPStartAccelerometerUpdatesConfirmation];
}


-(void)rsHook_startGyroUpdates {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdates) executionBlock:^{
        [weakSelf rsHook_startGyroUpdates];
    } executionBlockKey:kPPStartGyroUpdatesConfirmation];
}

-(void)rsHook_startGyroUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMGyroHandler)handler{
    
}

-(void)rsHook_startDeviceMotionUpdates {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdates) executionBlock:^{
        [weakSelf rsHook_startDeviceMotionUpdates];
    } executionBlockKey:kPPStartDeviceMotionUpdatesConfirmation];
}



-(BOOL)rsHook_isGyroAvailable{
    BOOL actualValue = [self rsHook_isGyroAvailable];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroAvailable) atKey:kPPMotionManagerIsGyroAvailableValue];
}



-(BOOL)rsHook_isAccelerometerAvailable {
    BOOL actualValue = [self rsHook_isAccelerometerAvailable];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsAccelerometerAvailable) atKey:kPPMotionManagerIsAccelerometerAvailableValue];
}

-(BOOL)rsHook_isMagnetometerAvailable {
    BOOL actualValue = [self rsHook_isMagnetometerAvailable];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerAvailable) atKey:kPPMotionManagerIsMagnetometerAvailableValue];
}

-(BOOL)rsHook_isDeviceMotionAvailable {
    BOOL actualValue = [self rsHook_isDeviceMotionAvailable];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionAvailable) atKey:kPPMotionManagerIsDeviceMotionAvailableValue];
}


-(BOOL)rsHook_isGyroActive{
    BOOL actualValue = [self rsHook_isGyroActive];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsGyroActiveValue];
}

-(BOOL)rsHook_isAccelerometerActive {
    BOOL actualValue = [self rsHook_isAccelerometerActive];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsAccelerometerActiveValue];
}

-(BOOL)rsHook_isMagnetometerActive {
    BOOL actualValue = [self rsHook_isMagnetometerActive];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerActive) atKey:kPPMotionManagerIsMagnetometerActiveValue];
}

-(BOOL)rsHook_isDeviceMotionActive {
    BOOL actualValue = [self rsHook_isDeviceMotionActive];
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionActive) atKey:kPPMotionManagerIsDeviceMotionActiveValue];
}

-(CMAccelerometerData *)rsHook_accelerometerData{
    CMAccelerometerData *data = [self rsHook_accelerometerData];
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentAccelerometerData) atKey:kPPMotionManagerGetCurrentAccelerometerDataValue];
}

-(CMGyroData *)rsHook_gyroData {
    CMGyroData *data = [self rsHook_gyroData];
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentGyroData) atKey:kPPMotionManagerGetCurrentGyroDataValue];
}

-(CMMagnetometerData *)rsHook_magnetometerData{
    CMMagnetometerData *data = [self rsHook_magnetometerData];
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentMagnetometerData) atKey:kPPMotionManagerGetCurrentMagnetometerDataValue];
}

-(CMDeviceMotion *)rsHook_deviceMotion {
    CMDeviceMotion *motion = [self rsHook_deviceMotion];
    return [[PPEventDispatcher sharedInstance] resultForEventValue:motion ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentDeviceMotion) atKey:kPPMotionManagerGetCurrentDeviceMotionValue];
}

@end
