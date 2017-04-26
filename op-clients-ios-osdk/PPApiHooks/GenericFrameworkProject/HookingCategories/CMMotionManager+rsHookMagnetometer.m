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
#import "NSObject+AutoSwizzle.h"

@interface CMMotionManager(rsHookUpdates)
@end

@implementation CMMotionManager(rsHookUpdates)
+(void)load {
    if (NSClassFromString(@"CMMotionManager")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}


HOOKEDInstanceMethod(void, setAccelerometerUpdateInterval:(NSTimeInterval)accelerometerUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerAccelerometerUpdateIntervalValue] = @(accelerometerUpdateInterval);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setAccelerometerUpdateInterval:[evData[kPPMotionManagerAccelerometerUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetAccelerometerUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}


HOOKEDInstanceMethod(void, setGyroUpdateInterval:(NSTimeInterval)gyroUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerGyroUpdateIntervalValue] = @(gyroUpdateInterval);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setGyroUpdateInterval:[evData[kPPMotionManagerGyroUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetGyroUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, setDeviceMotionUpdateInterval:(NSTimeInterval)deviceMotionUpdateInterval) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerDeviceMotionUpdateIntervalValue] = @(deviceMotionUpdateInterval);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setDeviceMotionUpdateInterval:[evData[kPPMotionManagerDeviceMotionUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetDeviceMotionUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}


HOOKEDInstanceMethod(void, setMagnetometerUpdateInterval:(NSTimeInterval)magnetometerUpdateInterval){
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPMotionManagerMagnetometerUpdateIntervalValue] = @(magnetometerUpdateInterval);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setMagnetometerUpdateInterval: [evData[kPPMotionManagerMagnetometerUpdateIntervalValue] doubleValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetMagnetometerUpdateInterval) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, startMagnetometerUpdates){
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdates) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, startMagnetometerUpdates);
        
    } executionBlockKey:kPPConfirmationCallbackBlock];
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
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, startAccelerometerUpdates) {
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdates) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, startAccelerometerUpdates);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKEDInstanceMethod(void, startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerAccelerometerHandler, handler);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *opQueue = evData[kPPMotionManagerUpdatesQueue];
        CMAccelerometerHandler accHandler = evData[kPPMotionManagerAccelerometerHandler];
        CALL_ORIGINAL_METHOD(weakSelf, startAccelerometerUpdatesToQueue:opQueue withHandler:accHandler);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}




HOOKEDInstanceMethod(void, startGyroUpdates) {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdates) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, startGyroUpdates);
        
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKEDInstanceMethod(void, startGyroUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMGyroHandler)handler) {
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerGyroHandler, handler)
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = evData[kPPMotionManagerUpdatesQueue];
        CMGyroHandler evHandler = evData[kPPMotionManagerGyroHandler];
        CALL_ORIGINAL_METHOD(weakSelf, startGyroUpdatesToQueue:evQueue withHandler:evHandler);
        
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartGyroUpdatesToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, startDeviceMotionUpdates) {
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdates) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, startDeviceMotionUpdates);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKEDInstanceMethod(void, startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame){
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    PPVoidBlock confirmationOrDefault = ^{
        CMAttitudeReferenceFrame refFrame = [evData[kPPDeviceMotionReferenceFrameValue] integerValue];
        CALL_ORIGINAL_METHOD(weakSelf, startDeviceMotionUpdatesUsingReferenceFrame:refFrame);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, startDeviceMotionUpdatesUsingReferenceFrame:(CMAttitudeReferenceFrame)referenceFrame toQueue:(NSOperationQueue *)queue withHandler:(CMDeviceMotionHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPMotionManagerUpdatesQueue, queue)
    SAFEADD(evData, kPPMotionManagerDeviceMotionHandler, handler)
    evData[kPPDeviceMotionReferenceFrameValue] = @(referenceFrame);
    
    PPVoidBlock confirmationOrDefault = ^{
        NSOperationQueue *evQueue = evData[kPPMotionManagerUpdatesQueue];
        CMDeviceMotionHandler evHandler = evData[kPPMotionManagerDeviceMotionHandler];
        CMAttitudeReferenceFrame evFrame = [evData[kPPDeviceMotionReferenceFrameValue] integerValue];
        CALL_ORIGINAL_METHOD(weakSelf, startDeviceMotionUpdatesUsingReferenceFrame:evFrame toQueue:evQueue withHandler:evHandler);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}


HOOKEDInstanceMethod(BOOL, isGyroAvailable){
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isGyroAvailable);
    
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroAvailable) atKey:kPPMotionManagerIsGyroAvailableValue];
}



HOOKEDInstanceMethod(BOOL, isAccelerometerAvailable) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isAccelerometerAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsAccelerometerAvailable) atKey:kPPMotionManagerIsAccelerometerAvailableValue];
}

HOOKEDInstanceMethod(BOOL, isMagnetometerAvailable) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isMagnetometerAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerAvailable) atKey:kPPMotionManagerIsMagnetometerAvailableValue];
}

HOOKEDInstanceMethod(BOOL, isDeviceMotionAvailable) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isDeviceMotionAvailable);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionAvailable) atKey:kPPMotionManagerIsDeviceMotionAvailableValue];
}


HOOKEDInstanceMethod(BOOL, isGyroActive){
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isGyroActive);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsGyroActiveValue];
}

HOOKEDInstanceMethod(BOOL, isAccelerometerActive) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isAccelerometerActive);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsGyroActive) atKey:kPPMotionManagerIsAccelerometerActiveValue];
}

HOOKEDInstanceMethod(BOOL, isMagnetometerActive) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isMagnetometerActive);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsMagnetometerActive) atKey:kPPMotionManagerIsMagnetometerActiveValue];
}

HOOKEDInstanceMethod(BOOL, isDeviceMotionActive) {
    BOOL actualValue = CALL_ORIGINAL_METHOD(self, isDeviceMotionActive);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:actualValue ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerIsDeviceMotionActive) atKey:kPPMotionManagerIsDeviceMotionActiveValue];
}

HOOKEDInstanceMethod(CMAccelerometerData *, accelerometerData){
    CMAccelerometerData *data = CALL_ORIGINAL_METHOD(self, accelerometerData);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentAccelerometerData) atKey:kPPMotionManagerGetCurrentAccelerometerDataValue];
}

HOOKEDInstanceMethod(CMGyroData*, gyroData) {
    CMGyroData *data = CALL_ORIGINAL_METHOD(self, gyroData);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentGyroData) atKey:kPPMotionManagerGetCurrentGyroDataValue];
}

HOOKEDInstanceMethod(CMMagnetometerData*, magnetometerData){
    CMMagnetometerData *data = CALL_ORIGINAL_METHOD(self, magnetometerData);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:data ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentMagnetometerData) atKey:kPPMotionManagerGetCurrentMagnetometerDataValue];
}

HOOKEDInstanceMethod(CMDeviceMotion*, deviceMotion) {
    CMDeviceMotion *motion = CALL_ORIGINAL_METHOD(self, deviceMotion);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:motion ofIdentifier:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerGetCurrentDeviceMotionData) atKey:kPPMotionManagerGetCurrentDeviceMotionValue];
}

@end
