//
//  CMMotionManager+rsHookMagnetometer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"
#import <CoreMotion/CoreMotion.h>
#import "NSObject+AutoSwizzle.h"
#import "CMMotionManager+PPHOOK.h"

PPEventDispatcher *_mmDispatcher;

@implementation CMMotionManager(PPHOOK)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher){
    _mmDispatcher = dispatcher;
}

HOOKPrefixInstance(void, setAccelerometerUpdateInterval:(NSTimeInterval)accelerometerUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    
    __Weak(evData);
    evData[kPPMotionManagerAccelerometerUpdateIntervalValue] = @(accelerometerUpdateInterval);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setAccelerometerUpdateInterval:[weakevData[kPPMotionManagerAccelerometerUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetAccelerometerUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}


HOOKPrefixInstance(void, setGyroUpdateInterval:(NSTimeInterval)gyroUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerGyroUpdateIntervalValue] = @(gyroUpdateInterval);
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setGyroUpdateInterval:[weakevData[kPPMotionManagerGyroUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetGyroUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}

HOOKPrefixInstance(void, setDeviceMotionUpdateInterval:(NSTimeInterval)deviceMotionUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerDeviceMotionUpdateIntervalValue] = @(deviceMotionUpdateInterval);
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setDeviceMotionUpdateInterval:[weakevData[kPPMotionManagerDeviceMotionUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetDeviceMotionUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    [_mmDispatcher fireEvent:event];
}


HOOKPrefixInstance(void, setMagnetometerUpdateInterval:(NSTimeInterval)magnetometerUpdateInterval){
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerMagnetometerUpdateIntervalValue] = @(magnetometerUpdateInterval);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setMagnetometerUpdateInterval: [evData[kPPMotionManagerMagnetometerUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetMagnetometerUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}

HOOKPrefixInstance(void, startMagnetometerUpdates){
    __weak typeof(self) weakSelf = self;
    
    [_mmDispatcher fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdates) executionBlock:^{
        CALL_PREFIXED(weakSelf, startMagnetometerUpdates);
        
    } executionBlockKey:kPPConfirmationCallbackBlock];
}


-(void)rsHook_startMagnetometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMMagnetometerHandler)handler {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerMagnetometerHandler, handler)
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = weakevData[kPPMotionManagerUpdatesQueue];
        CMMagnetometerHandler evHandler = weakevData[kPPMotionManagerMagnetometerHandler];
        [weakSelf rsHook_startMagnetometerUpdatesToQueue:evQueue withHandler:evHandler];
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}

HOOKPrefixInstance(void, startAccelerometerUpdates) {
    __weak typeof(self) weakSelf = self;
    
    [_mmDispatcher fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdates) executionBlock:^{
        CALL_PREFIXED(weakSelf, startAccelerometerUpdates);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKPrefixInstance(void, startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerAccelerometerHandler, handler);
    
    __Weak(evData);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *opQueue = weakevData[kPPMotionManagerUpdatesQueue];
        CMAccelerometerHandler accHandler = weakevData[kPPMotionManagerAccelerometerHandler];
        CALL_PREFIXED(weakSelf, startAccelerometerUpdatesToQueue:opQueue withHandler:accHandler);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}




HOOKPrefixInstance(void, startGyroUpdates) {
    __weak typeof(self) weakSelf = self;
    [_mmDispatcher fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdates) executionBlock:^{
        CALL_PREFIXED(weakSelf, startGyroUpdates);
        
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKPrefixInstance(void, startGyroUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMGyroHandler)handler) {
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerGyroHandler, handler)
    __Weak(evData);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = weakevData[kPPMotionManagerUpdatesQueue];
        CMGyroHandler evHandler = weakevData[kPPMotionManagerGyroHandler];
        CALL_PREFIXED(weakSelf, startGyroUpdatesToQueue:evQueue withHandler:evHandler);
        
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}

HOOKPrefixInstance(void, startDeviceMotionUpdates) {
    __weak typeof(self) weakSelf = self;
    [_mmDispatcher fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdates) executionBlock:^{
        CALL_PREFIXED(weakSelf, startDeviceMotionUpdates);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKPrefixInstance(void, startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame){
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CMAttitudeReferenceFrame refFrame = [weakevData[kPPDeviceMotionReferenceFrameValue] integerValue];
        CALL_PREFIXED(weakSelf, startDeviceMotionUpdatesUsingReferenceFrame:refFrame);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}

HOOKPrefixInstance(void, startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame toQueue:(NSOperationQueue *)queue withHandler:(CMDeviceMotionHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerDeviceMotionHandler, handler)
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    __Weak(evData);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = weakevData[kPPMotionManagerUpdatesQueue];
        CMDeviceMotionHandler evHandler = weakevData[kPPMotionManagerDeviceMotionHandler];
        CMAttitudeReferenceFrame evFrame = [weakevData[kPPDeviceMotionReferenceFrameValue] integerValue];
        CALL_PREFIXED(weakSelf, startDeviceMotionUpdatesUsingReferenceFrame:evFrame toQueue:evQueue withHandler:evHandler);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_mmDispatcher fireEvent:event];
}


HOOKPrefixInstance(BOOL, isGyroAvailable){
    BOOL actualValue = CALL_PREFIXED(self, isGyroAvailable);
    
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroAvailable) atKey:kPPMotionManagerIsGyroAvailableValue];
}



HOOKPrefixInstance(BOOL, isAccelerometerAvailable) {
    BOOL actualValue = CALL_PREFIXED(self, isAccelerometerAvailable);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsAccelerometerAvailable) atKey:kPPMotionManagerIsAccelerometerAvailableValue];
}

HOOKPrefixInstance(BOOL, isMagnetometerAvailable) {
    BOOL actualValue = CALL_PREFIXED(self, isMagnetometerAvailable);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerAvailable) atKey:kPPMotionManagerIsMagnetometerAvailableValue];
}

HOOKPrefixInstance(BOOL, isDeviceMotionAvailable) {
    BOOL actualValue = CALL_PREFIXED(self, isDeviceMotionAvailable);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionAvailable) atKey:kPPMotionManagerIsDeviceMotionAvailableValue];
}


HOOKPrefixInstance(BOOL, isGyroActive){
    BOOL actualValue = CALL_PREFIXED(self, isGyroActive);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsGyroActiveValue];
}

HOOKPrefixInstance(BOOL, isAccelerometerActive) {
    BOOL actualValue = CALL_PREFIXED(self, isAccelerometerActive);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsAccelerometerActiveValue];
}

HOOKPrefixInstance(BOOL, isMagnetometerActive) {
    BOOL actualValue = CALL_PREFIXED(self, isMagnetometerActive);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerActive) atKey:kPPMotionManagerIsMagnetometerActiveValue];
}

HOOKPrefixInstance(BOOL, isDeviceMotionActive) {
    BOOL actualValue = CALL_PREFIXED(self, isDeviceMotionActive);
    return [_mmDispatcher resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionActive) atKey:kPPMotionManagerIsDeviceMotionActiveValue];
}

HOOKPrefixInstance(CMAccelerometerData *, accelerometerData){
    CMAccelerometerData *data = CALL_PREFIXED(self, accelerometerData);
    return [_mmDispatcher resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentAccelerometerData) atKey:kPPMotionManagerGetCurrentAccelerometerDataValue];
}

HOOKPrefixInstance(CMGyroData*, gyroData) {
    CMGyroData *data = CALL_PREFIXED(self, gyroData);
    return [_mmDispatcher resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentGyroData) atKey:kPPMotionManagerGetCurrentGyroDataValue];
}

HOOKPrefixInstance(CMMagnetometerData*, magnetometerData){
    CMMagnetometerData *data = CALL_PREFIXED(self, magnetometerData);
    return [_mmDispatcher resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentMagnetometerData) atKey:kPPMotionManagerGetCurrentMagnetometerDataValue];
}

HOOKPrefixInstance(CMDeviceMotion*, deviceMotion) {
    CMDeviceMotion *motion = CALL_PREFIXED(self, deviceMotion);
    return [_mmDispatcher resultForEventValue:motion ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentDeviceMotionData) atKey:kPPMotionManagerGetCurrentDeviceMotionValue];
}

@end
