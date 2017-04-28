//
//  UIDevice+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "PPEvent.h"
#import "Common.h"
#import "PPEventDispatcher+Internal.h"
#import "NSObject+AutoSwizzle.h"

@interface UIDevice(rsHook)

@end

@implementation UIDevice(rsHook)

+(void)load{
    [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
}

HOOKEDInstanceMethod(void, setProximityMonitoringEnabled:(BOOL)enabled) {
    
    __weak typeof(self) weakSelf = self;
    
    PPEventIdentifier eventType = PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceSetProximityMonitoringEnabled);
    
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximityMonitoringEnabledValue: @(enabled)
                                     } mutableCopy];
    
    __Weak(evData);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setProximityMonitoringEnabled:[weakevData[kPPDeviceProximityMonitoringEnabledValue] boolValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:eventType eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(void, setProximitySensingEnabled:(BOOL)enabled) {
    
    __weak typeof(self) weakSelf = self;
    PPEventIdentifier eventType = PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceSetProximitySensingEnabled);
    
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximitySensingEnabledValue: @(enabled)
                                     } mutableCopy];
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_ORIGINAL_METHOD(weakSelf, setProximitySensingEnabled:[weakevData[kPPDeviceProximitySensingEnabledValue] boolValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:eventType eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
}

HOOKEDInstanceMethod(BOOL, proximityState) {
    
    BOOL actualProximityState = CALL_ORIGINAL_METHOD(self, proximityState);
    NSMutableDictionary *dict = [@{kPPDeviceProxmityStateValue: @(actualProximityState)} mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetProximityState) eventData:dict whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    NSNumber *possiblyModifiedValue = dict[kPPDeviceProxmityStateValue];
    if (!(possiblyModifiedValue && [possiblyModifiedValue isKindOfClass:[NSNumber class]])){
        return actualProximityState;
    }
    
    return [possiblyModifiedValue boolValue];
}

HOOKEDInstanceMethod(NSString*, name){
    NSString *actualName = CALL_ORIGINAL_METHOD(self, name);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualName ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetName) atKey:kPPDeviceNameValue];
}

HOOKEDInstanceMethod(NSString*, model){
    NSString *actualModel = CALL_ORIGINAL_METHOD(self, model);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualModel ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetModel) atKey:kPPDeviceModelValue];
}

HOOKEDInstanceMethod(NSString*, localizedModel){
    NSString *actualLocalizedModel = CALL_ORIGINAL_METHOD(self, localizedModel);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualLocalizedModel ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetLocalizedModel) atKey:kPPDeviceLocalizedModelValue];
}

HOOKEDInstanceMethod(NSString*, systemName){
    NSString *actualSystemName = CALL_ORIGINAL_METHOD(self, systemName);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualSystemName ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetSystemName) atKey:kPPDeviceSystemNameValue];
}

HOOKEDInstanceMethod(NSString*, systemVersion){
    NSString *actualSystemVersion = CALL_ORIGINAL_METHOD(self, systemVersion);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualSystemVersion ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetSystemVersion) atKey:kPPDeviceSystemVersionValue];
}

HOOKEDInstanceMethod(NSString*, identifierForVendor) {
    NSString *actualUUID = CALL_ORIGINAL_METHOD(self, identifierForVendor);
    return [[PPEventDispatcher sharedInstance] resultForEventValue:actualUUID ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetIdentifierForVendor) atKey:kPPDeviceUUIDValue];
}


@end
