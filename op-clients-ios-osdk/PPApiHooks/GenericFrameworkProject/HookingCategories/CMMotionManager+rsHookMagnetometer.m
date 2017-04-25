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
        [self jr_swizzleMethod:@selector(setAccelerometerUpdateInterval:) withMethod:@selector(rsHook_setAccelerometerUpdateInterval:) error:nil];
        
        [self jr_swizzleMethod:@selector(setGyroUpdateInterval:) withMethod:@selector(rsHook_setGyroUpdateInterval:) error:nil];
        
        [self jr_swizzleMethod:@selector(setDeviceMotionUpdateInterval:) withMethod:@selector(rsHook_setDeviceMotionUpdateInterval:) error:nil];
        
        [self jr_swizzleMethod:@selector(setMagnetometerUpdateInterval:) withMethod:@selector(rsHook_setMagnetometerUpdateInterval:) error:nil];
        
        [self jr_swizzleMethod:@selector(startMagnetometerUpdates) withMethod:@selector(rsHook_startMagnetometerUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startMagnetometerUpdatesToQueue:withHandler:) withMethod:@selector(rsHook_startMagnetometerUpdatesToQueue:withHandler:) error:nil];
        
        [self jr_swizzleMethod:@selector(startAccelerometerUpdates) withMethod:@selector(rsHook_startAccelerometerUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startAccelerometerUpdatesToQueue:withHandler:) withMethod:@selector(rsHook_startAccelerometerUpdatesToQueue:withHandler:) error:nil];
        
        [self jr_swizzleMethod:@selector(startGyroUpdates) withMethod:@selector(rsHook_startGyroUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startGyroUpdatesToQueue:withHandler:) withMethod:@selector(rsHook_startGyroUpdatesToQueue:withHandler:) error:nil];
        
        
        [self jr_swizzleMethod:@selector(startDeviceMotionUpdates) withMethod:@selector(rsHook_startDeviceMotionUpdates) error:nil];
        
        [self jr_swizzleMethod:@selector(startDeviceMotionUpdatesUsingReferenceFrame:) withMethod:@selector(rsHook_startDeviceMotionUpdatesUsingReferenceFrame:) error:nil];
        
        [self jr_swizzleMethod:@selector(startDeviceMotionUpdatesUsingReferenceFrame:toQueue:withHandler:) withMethod:@selector(rsHook_startDeviceMotionUpdatesUsingReferenceFrame:toQueue:withHandler:) error:nil];
        
        
    }
}


-(void)rsHook_setAccelerometerUpdateInterval:(NSTimeInterval)accelerometerUpdateInterval {
    
    NSNumber *valueFromEvent = [[PPEventDispatcher sharedInstance] resultForEventValue:@(accelerometerUpdateInterval) ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetAccelerometerUpdateInterval) atKey:kPPMotionManagerAccelerometerUpdateIntervalValue];
    
    [self rsHook_setAccelerometerUpdateInterval:valueFromEvent.doubleValue];
}


-(void)rsHook_setGyroUpdateInterval:(NSTimeInterval)gyroUpdateInterval {
    NSNumber *valueFromEvent = [[PPEventDispatcher sharedInstance] resultForEventValue:@(gyroUpdateInterval) ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetGyroUpdateInterval) atKey:kPPMotionManagerGyroUpdateIntervalValue];
    
    [self rsHook_setGyroUpdateInterval:valueFromEvent.doubleValue];
}

-(void)rsHook_setDeviceMotionUpdateInterval:(NSTimeInterval)deviceMotionUpdateInterval{
    NSNumber *valueFromEvent = [[PPEventDispatcher sharedInstance] resultForEventValue:@(deviceMotionUpdateInterval) ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetDeviceMotionUpdateInterval) atKey:kPPMotionManagerDeviceMotionUpdateIntervalValue];
    
    [self rsHook_setDeviceMotionUpdateInterval:valueFromEvent.doubleValue];
}

-(void)rsHook_setMagnetometerUpdateInterval:(NSTimeInterval)magnetometerUpdateInterval{
    NSNumber *valueFromEvent = [[PPEventDispatcher sharedInstance] resultForEventValue:@(magnetometerUpdateInterval) ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetMagnetometerUpdateInterval) atKey:kPPMotionManagerMagnetometerUpdateIntervalValue];
    
    [self rsHook_setDeviceMotionUpdateInterval:valueFromEvent.doubleValue];
}

-(void)rsHook_startMagnetometerUpdates{
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdates) executionBlock:^{
        [weakSelf rsHook_startMagnetometerUpdates];
    } executionBlockKey:kConfirmationCallbackBlock];
}


-(void)rsHook_startMagnetometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMMagnetometerHandler)handler {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerMagnetometerHandler, handler)
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = evData[kPPMotionManagerUpdatesQueue];
        CMMagnetometerHandler evHandler = evData[kPPMotionManagerMagnetometerHandler];
        [weakSelf rsHook_startMagnetometerUpdatesToQueue:evQueue withHandler:evHandler];
    };
    evData[kConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

-(void)rsHook_startAccelerometerUpdates {
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdates) executionBlock:^{
        [weakSelf rsHook_startAccelerometerUpdates];
    } executionBlockKey:kConfirmationCallbackBlock];
}

-(void)rsHook_startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerAccelerometerHandler, handler);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *opQueue = evData[kPPMotionManagerUpdatesQueue];
        CMAccelerometerHandler accHandler = evData[kPPMotionManagerAccelerometerHandler];
        [weakSelf rsHook_startAccelerometerUpdatesToQueue:opQueue withHandler:accHandler];
    };
    evData[kConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}




-(void)rsHook_startGyroUpdates {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdates) executionBlock:^{
        [weakSelf rsHook_startGyroUpdates];
    } executionBlockKey:kConfirmationCallbackBlock];
}

-(void)rsHook_startGyroUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMGyroHandler)handler {
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerGyroHandler, handler)
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = evData[kPPMotionManagerUpdatesQueue];
        CMGyroHandler evHandler = evData[kPPMotionManagerGyroHandler];
        [weakSelf rsHook_startGyroUpdatesToQueue:evQueue withHandler:evHandler];
    };
    evData[kConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

-(void)rsHook_startDeviceMotionUpdates {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdates) executionBlock:^{
        [weakSelf rsHook_startDeviceMotionUpdates];
    } executionBlockKey:kConfirmationCallbackBlock];
}

-(void)rsHook_startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    PPVoidBlock confirmationOrDefault = ^{
        CMAttitudeReferenceFrame refFrame = [evData[kPPDeviceMotionReferenceFrameValue] integerValue];
        [weakSelf rsHook_startDeviceMotionUpdatesUsingReferenceFrame:refFrame];
    };
    evData[kConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

-(void)rsHook_startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame toQueue:(NSOperationQueue *)queue withHandler:(CMDeviceMotionHandler)handler {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerDeviceMotionHandler, handler)
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = evData[kPPMotionManagerUpdatesQueue];
        CMDeviceMotionHandler evHandler = evData[kPPMotionManagerDeviceMotionHandler];
        CMAttitudeReferenceFrame evFrame = [evData[kPPDeviceMotionReferenceFrameValue] integerValue];
        [weakSelf rsHook_startDeviceMotionUpdatesUsingReferenceFrame:evFrame toQueue:evQueue withHandler:evHandler];
    };
    
    evData[kConfirmationCallbackBlock] = confirmationOrDefault;
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
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
    return [[PPEventDispatcher sharedInstance] resultForEventValue:motion ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentDeviceMotionData) atKey:kPPMotionManagerGetCurrentDeviceMotionValue];
}

@end
