//
//  AVCaptureDevice+rsHookCamera.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "NSObject+AutoSwizzle.h"
#import "PPEventDispatcher+Internal.h"

@interface AVCaptureDevice(rsHook)

@end

@implementation AVCaptureDevice(rsHook)

+(void)load {
    if (NSClassFromString(@"AVCaptureDevice")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}


HOOKEDClassMethod(AVCaptureDevice*, defaultDeviceWithMediaType:(NSString *)mediaType){
    AVCaptureDevice *defaultDevice = CALL_ORIGINAL_METHOD(self, defaultDeviceWithMediaType:mediaType);
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPCaptureDeviceMediaTypeValue, defaultDevice)
    SAFEADD(evData, kPPCaptureDeviceDefaultDeviceValue, mediaType)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetDefaultDeviceWithMediaType) eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    return evData[kPPCaptureDeviceDefaultDeviceValue];
}

HOOKEDClassMethod(AVCaptureDevice*, defaultDeviceWithDeviceType:(AVCaptureDeviceType)deviceType mediaType:(NSString *)mediaType position:(AVCaptureDevicePosition)position){
    AVCaptureDevice *def = CALL_ORIGINAL_METHOD(self, defaultDeviceWithDeviceType:deviceType mediaType:mediaType position:position);
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    SAFEADD(eventData, kPPCaptureDeviceDefaultDeviceValue, def)
    SAFEADD(eventData, kPPCaptureDeviceMediaTypeValue, mediaType)
    eventData[kPPCaptureDevicePositionValue] = @(position);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition) eventData:eventData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    return eventData[kPPCaptureDeviceDefaultDeviceValue];
    
}


HOOKEDInstanceMethod(NSString*, uniqueID){
    NSString *result = CALL_ORIGINAL_METHOD(self, uniqueID);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:result ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetUniqueId) atKey:kPPCaptureDeviceUniqueIdValue];
}


HOOKEDInstanceMethod(NSString*, modelID){
    NSString *result = CALL_ORIGINAL_METHOD(self, modelID);
        return [[PPEventDispatcher sharedInstance] resultForEventValue:result ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetModelId) atKey:kPPCaptureDeviceModelIdValue];
}

HOOKEDInstanceMethod(BOOL, hasMediaType:(NSString *)mediaType){
    BOOL result = CALL_ORIGINAL_METHOD(self, hasMediaType: mediaType);
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPCaptureDeviceMediaTypeValue, mediaType)
    evData[kPPCaptureDeviceHasMediaTypeResult] = @(result);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceHasMediaType) eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    return [evData[kPPCaptureDeviceHasMediaTypeResult] boolValue];
}


HOOKEDInstanceMethod(BOOL, lockForConfiguration:(NSError *__autoreleasing *)outError){
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceLockForConfiguration) eventData:eventData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    if ([eventData[kPPCaptureDeviceConfirmationBool] boolValue]) {
        return CALL_ORIGINAL_METHOD(self, lockForConfiguration: outError);
    }
    
    *outError = eventData[kPPCaptureDeviceErrorValue];
    return NO;
}

HOOKEDClassMethod(BOOL, supportsAVCaptureSessionPreset:(NSString *)preset){
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    SAFEADD(eventData, kPPAVPresetValue, preset)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceSupportsSessionPreset) eventData:eventData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    if ([eventData[kPPCaptureDeviceConfirmationBool] boolValue]) {
        return CALL_ORIGINAL_METHOD(self, supportsAVCaptureSessionPreset: preset);
    }
    
    return NO;
}


HOOKEDInstanceMethod(BOOL, isConnected){
    BOOL connected = CALL_ORIGINAL_METHOD(self, isConnected);
    return [[PPEventDispatcher sharedInstance] resultForBoolEventValue:connected ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetIsConnected) atKey:kPPCaptureDeviceConfirmationBool];
}

HOOKEDInstanceMethod(NSArray*, formats){
    NSArray *formats = CALL_ORIGINAL_METHOD(self, formats);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:formats ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetFormats) atKey:kPPCaptureDeviceFormatsArrayValue];
}

HOOKEDInstanceMethod(AVCaptureDeviceFormat*, activeFormat){
    AVCaptureDeviceFormat *format = CALL_ORIGINAL_METHOD(self, activeFormat);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:format ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetActiveFormat) atKey:kPPCaptureDeviceActiveFormatValue];
}

@end
