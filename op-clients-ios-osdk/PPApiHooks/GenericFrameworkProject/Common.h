//
//  PPEventKeys.h
//  PPApiHooks
//
//  Created by Costin Andronache on 3/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef PPEventKeys_h
#define PPEventKeys_h


#define PPHOOKPREFIX @"__PP_HOOKED__"
#define HOOKEDInstanceMethod(retType, call) -(retType)__PP_HOOKED__##call
#define HOOKEDClassMethod(retType, call) +(retType)__PP_HOOKED__##call
#define CALL_ORIGINAL_METHOD(callee, call) [callee __PP_HOOKED__##call]

#define SAFECALL(x, ...) if(x){x(__VA_ARGS__);}
#define SAFEADD(dict, key, value) if(value){[dict setObject:value forKey:key];}

#define __Weak(x) __weak typeof(x) weak##x = x

typedef void(^PPBoolErrorBlock)(BOOL, NSError* _Nullable);

typedef void(^PPVoidBlock)();

typedef NS_ENUM(NSInteger, PPEventType) {
    PPLocationManagerEvent,
    PPMotionManagerEvent,
    PPURLSessionEvent,
    PPUIDeviceEvent,
    PPPedometerEvent,
    PPWKWebViewEvent,
    PPLAContextEvent,
    PPCNContactStoreEvent,
    PPCMAltimeterEvent,
    PPAVCaptureDeviceEvent
};

typedef NS_ENUM(NSInteger, PPLocationManagerEventType){
    EventLocationManagerStartLocationUpdates,
    EventLocationManagerRequestAlwaysAuthorization,
    EventLocationManagerRequestWhenInUseAuthorization,
    EventLocationManagerSetDelegate,
    EventLocationManagerGetCurrentLocation,
};


typedef NS_ENUM(NSInteger, PPMotionManagerEventType){
    EventMotionManagerStartAccelerometerUpdates,
    EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler,
    
    EventMotionManagerStartGyroUpdates,
    EventMotionManagerStartGyroUpdatesToQueueUsingHandler,
    
    EventMotionManagerStartMagnetometerUpdates,
    EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler,
    
    EventMotionManagerStartDeviceMotionUpdates,
    EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame,
    EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler,
    
    EventMotionManagerIsGyroAvailable,
    EventMotionManagerIsAccelerometerAvailable,
    EventMotionManagerIsMagnetometerAvailable,
    EventMotionManagerIsDeviceMotionAvailable,
    
    EventMotionManagerIsGyroActive,
    EventMotionManagerIsAccelerometerActive,
    EventMotionManagerIsMagnetometerActive,
    EventMotionManagerIsDeviceMotionActive,
    
    EventMotionManagerGetCurrentGyroData,
    EventMotionManagerGetCurrentAccelerometerData,
    EventMotionManagerGetCurrentMagnetometerData,
    EventMotionManagerGetCurrentDeviceMotionData,
    
    EventMotionManagerSetGyroUpdateInterval,
    EventMotionManagerSetAccelerometerUpdateInterval,
    EventMotionManagerSetMagnetometerUpdateInterval,
    EventMotionManagerSetDeviceMotionUpdateInterval
};

typedef NS_ENUM(NSInteger, PPURLSessionEventType){
    EventURLSessionStartDataTaskForRequest
};

typedef NS_ENUM(NSInteger, PPUIDeviceEventType){
    EventDeviceSetProximityMonitoringEnabled,
    EventDeviceSetProximitySensingEnabled,
    EventDeviceGetProximityState,
    EventDeviceGetName,
    EventDeviceGetModel,
    EventDeviceGetLocalizedModel,
    EventDeviceGetSystemName,
    EventDeviceGetSystemVersion,
    EventDeviceGetIdentifierForVendor
};

typedef NS_ENUM(NSInteger, PPPedometerEventType){
    EventPedometerStartUpdatesFromDate,
    EventPedometerGetStepCountingAvailable,
    EventPedometerGetDistanceAvailable,
    EventPedometerGetFloorCountingAvailable,
    EventPedometerGetPaceAvailable,
    EventPedometerGetCadenceAvailable,
    EventPedometerGetTrackingAvailable,
    EventPedometerQueryDataFromDate,
    EventPedometerStartEventUpdatesWithHandler,
    EventPedometerGetEventTrackingAvailable
    
};

typedef NS_ENUM(NSInteger, PPWKWebViewEventType){
    EventAllowWebViewRequest
};

typedef NS_ENUM(NSInteger, PPLAContextEventType) {
    EventContextCanEvaluatePolicy,
    EventContextEvaluatePolicy,
    EventContextEvaluateAccessControlForOperation,
};

typedef NS_ENUM(NSInteger, PPCNContactStoreEventType){
    EventContactStoreGetAuthorizationStatusForEntityType,
    EventContactStoreRequestAccessForEntityType,
    EventContactStoreGetUnifiedContactsMatchingPredicate,
    EventContactStoreGetUnifiedContactWithIdentifier,
    EventContactStoreGetUnifiedMeContact,
    EventContactStoreEnumerateContactsWithFetchRequest,
    EventContactStoreGetGroupsMatchingPredicate,
    EventContactStoreGetContainersMatchingPredicate,
    EventContactsStoreGetDefaultContainerIdentifier,
    EventContactsStoreExecuteSaveRequest
};

typedef NS_ENUM(NSInteger, PPCMAltimeterEventType) {
    EventAltimeterGetRelativeAltitudeAvailableValue,
    EventAltimeterStartRelativeAltitudeUpdates,
};

typedef NS_ENUM(NSInteger, PPAVCaptureDeviceEventType) {
    EventCaptureDeviceGetDefaultDeviceWithMediaType,
    EventCaptureDeviceGetDeviceWithUniqueId,
    EventCaptureDeviceGetUniqueId,
    EventCaptureDeviceGetModelId,
    EventCaptureDeviceHasMediaType,
    EventCaptureDeviceLockForConfiguration,
    EventCaptureDeviceSupportsSessionPreset,
    EventCaptureDeviceGetIsConnected,
    EventCaptureDeviceGetFormats,
    EventCaptureDeviceGetActiveFormat,
    EventCaptureDeviceGetActiveVideoMinFrameDuration,
    EventCaptureDeviceGetActiveVideoMaxFrameDuration,
    EventCaptureDeviceGetPosition,
    EventCaptureDeviceGetDeviceType,
    EventCaptureDeviceGetDefaultDeviceWithType,
    EventCaptureDeviceGetHasFlash,
    EventCaptureDeviceGetIsFlashAvailable,
    EventCaptureDeviceGetHasTorch,
    EventCaptureDeviceGetTorchAvailable,
    EventCaptureDeviceGetTorchActive,
    EventCaptureDeviceGetTorchLevel,
    EventCaptureDeviceIsTorchModeSupported,
    EventCaptureDeviceGetTorchMode,
    EventCaptureDeviceSetTorchModeWithLevel
    
};

#define kPPConfirmationCallbackBlock @"kCommonConfirmationVoidBlock"

#pragma mark - 

#define kPPWebViewRequest @"kPPWebViewRequest"
#define kPPAllowWebViewRequestValue @"kPPAllowWebViewRequestValue"

#pragma mark - NSURLSession related keys

#define kPPURLSessionDataTask @"kURLSessionDataTask"
#define kPPURLSessionDataTaskRequest @"kPPURLSessionDataTaskRequest"
#define kPPURLSessionDataTaskResponse @"kPPURLSessionDataTaskResponse"
#define kPPURLSessionDatTaskResponseData @"kPPURLSessionDatTaskResponseData"
#define kPPURLSessionDataTaskError @"kPPURLSessionDataTaskError"

#pragma mark - 
// - CLLocationManager related keys

//#define kPPStartLocationUpdatesConfirmation @"kPPStartLocationUpdatesConfirmationKey"
//#define kPPRequestAlwaysAuthorizationConfirmation @"kPPRequestAlwaysAuthorizationConfirmation"
//#define kPPRequestWhenInUseAuthorizationConfirmation @"kPPRequestWhenInUseAuthorizationConfirmation"


#define kPPLocationManagerDelegate @"kPPLocationManagerDelegate"
#define kPPLocationManagerInstance @"kPPLocationManagerInstance"
#define kPPLocationManagerSetDelegateConfirmation @"kPPLocationManagerSetDelegateConfirmation"

#define kPPLocationManagerGetCurrentLocationValue @"kPPLocationManagerGetCurrentLocationValue"

#pragma mark - CMMotionManager related keys
// - CMMotionManager related keys



#define kPPMotionManagerIsGyroAvailableValue @"kPPMotionManagerIsGyroAvailableValue"

#define kPPMotionManagerIsAccelerometerAvailableValue @"kPPMotionManagerIsAccelerometerAvailableValue"

#define kPPMotionManagerIsAccelerometerActiveValue @"kPPMotionManagerIsAccelerometerActiveValue"

#define kPPMotionManagerIsMagnetometerActiveValue @"kPPMotionManagerIsMagnetometerActiveValue"

#define kPPMotionManagerIsDeviceMotionActiveValue @"kPPMotionManagerIsDeviceMotionActiveValue"

#define kPPMotionManagerIsDeviceMotionAvailableValue @"kPPMotionManagerIsDeviceMotionAvailableValue"
#define kPPMotionManagerIsGyroActiveValue @"kPPMotionManagerIsGyroActiveValue"
#define kPPMotionManagerIsMagnetometerAvailableValue @"kPPMotionManagerIsMagnetometerAvailableValue"

#define kPPMotionManagerGetCurrentAccelerometerDataValue @"kPPMotionManagerGetCurrentAccelerometerDataValue"
#define kPPMotionManagerGetCurrentGyroDataValue @"kPPMotionManagerGetCurrentGyroDataValue"
#define kPPMotionManagerGetCurrentMagnetometerDataValue @"kPPMotionManagerGetCurrentMagnetometerDataValue"
#define kPPMotionManagerGetCurrentDeviceMotionValue @"kPPMotionManagerGetCurrentDeviceMotionValue"

#define kPPDeviceMotionReferenceFrameValue @"kPPDeviceMotionReferenceFrameValue"

#define kPPMotionManagerUpdatesQueue @"kPPMotionManagerUpdatesQueue"
#define kPPMotionManagerAccelerometerHandler @"kPPMotionManagerAccelerometerHandler"
#define kPPMotionManagerMagnetometerHandler @"kPPMotionManagerMagnetometerHandler"
#define kPPMotionManagerGyroHandler @"kPPMotionManagerGyroHandler"
#define kPPMotionManagerDeviceMotionHandler @"kPPMotionManagerDeviceMotionHandler"

#define kPPMotionManagerAccelerometerUpdateIntervalValue @"kPPMotionManagerAccelerometerUpdateIntervalValue"
#define kPPMotionManagerGyroUpdateIntervalValue @"kPPMotionManagerGyroUpdateIntervalValue"
#define kPPMotionManagerMagnetometerUpdateIntervalValue @"kPPMotionManagerMagnetometerUpdateIntervalValue"
#define kPPMotionManagerDeviceMotionUpdateIntervalValue @"kPPMotionManagerDevieMotionUpdateIntervalValue"

#pragma mark - UIDevice & proximity related keys
// - UIDevice & proximity related keys

#define kPPDeviceProximityMonitoringEnabledValue @"kPPDeviceProximityMonitoringEnabledValue"
#define kPPDeviceProximitySensingEnabledValue @"kPPDeviceProximitySensingEnabledValue"
#define kPPDeviceProxmityStateValue @"kPPDeviceProxmityStateValue"
#define kPPDeviceNameValue @"kPPDeviceNameValue"
#define kPPDeviceModelValue @"kPPDeviceNameValue"
#define kPPDeviceLocalizedModelValue @"kPPDeviceLocalizedModelValue"
#define kPPDeviceUUIDValue @"kPPDeviceUUIDValue"
#define kPPDeviceSystemNameValue @"kPPDeviceSystemNameValue"
#define kPPDeviceSystemVersionValue @"kPPDeviceSystemVersionValue"


#pragma mark - CMPedometer related keys
// -
#define kPPPedometerUpdatesDateValue @"kPPPedometerUpdateDateValue"
#define kPPPedometerHandlerValue @"kPPPedometerHandlerValue"
#define kPPPedometerIsStepCountingAvailableValue @"kPPPedometerIsStepCountingAvailable"
#define kPPPedometerIsDistanceAvailableValue @"kPPPedometerIsDistanceAvailableValue"
#define kPPPedometerIsFloorCountingAvailableValue @"kPPPedometerIsFloorCountingAvailableValue"
#define kPPPedometerIsPaceAvailableValue @"kPPPedometerIsPaceAvailableValue"
#define kPPPedometerIsCadenceAvailableValue @"kPPPedometerIsCadenceAvailableValue"
#define kPPPedometerIsEventTrackingAvailableValue @"kPPPedometerIsEventTrackingAvailableValue"
#define kPPPedometerEventUpdatesHandler @"kPPPedometerEventUpdatesHandler"
#define kPPPedometerStartDateValue @"kPPPedometerStartDateValue"
#define kPPPedometerEndDateValue @"kPPPedometerEndDateValue"

#pragma mark - LAContext related keys

#define kPPContextPolicyValue @"kPPContextPolicyValue"
#define kPPContextErrorValue @"kPPContextErrorValue"
#define kPPContextCanEvaluateContextPolicyValue @"kPPContextCanEvaluateContextPolicyValue"
#define kPPContextBOOLErrorReplyBlock @"kPPContextBOOLErrorReplyBlock"
#define kPPContextSecAccessControlRefValue @"kPPContextSecAccessControlRefValue"
#define kPPContextAccessControlOperationValue @"kPPContextAccessControlOperationValue"

#pragma mark - CNContactStore related keys

#define kPPContactStoreAuthorizationStatusValue @"kPPContactStoreAuthorizationStatusValue"
#define kPPContactStoreEntityTypeValue @"kPPContactStoreEntityTypeValue"
#define kPPContactStoreDefaultIdentifierValue @"kPPContactStoreDefaultIdentifierValue"
#define kPPContactStoreSaveRequestValue @"kPPContactStoreSaveRequestValue"
#define kPPContactStorePredicateValue @"kPPContactStorePredicateValue"
#define kPPContactStoreErrorValue @"kPPContactStoreErrorValue"
#define kPPContactStoreContactsArrayValue @"kPPContactStoreContactsArrayValue"
#define kPPContactStoreContactValue @"kPPContactStoreContactValue"

#define kPPContactStoreEnumerateContactsBoolReturnValue @"kPPContactStoreEnumerateContactsBoolReturnValue"
#define kPPContactStoreContainersArrayValue @"kPPContactStoreContainersArrayValue"
#define kPPContactStoreGroupsArrayValue @"kPPContactStoreGroupsArrayValue"
#define kPPContactStoreFetchRequestValue @"kPPContactStoreFetchRequestValue"
#define kPPContactStoreBOOLErrorBlock @"kPPContactStoreBOOLErrorBlock"
#define kPPContactStoreKeyDescriptorsArrayValue @"kPPContactStoreKeyDescriptorsArrayValue"
#define kPPContactStoreUnifiedContactIdentifierValue @"kPPContactStoreUnifiedContactIdentifierValue"

#define kPPContactStoreContactEnumerationBlock @"kPPContactStoreContactEnumerationBlock"
#define kPPContactStoreBOOLReturnValue @"kPPContactStoreBOOLReturnValue"
#define kPPContactStoreAllowExecuteSaveRequest @"kPPContactStoreAllowExecuteSaveRequest"

#pragma mark - CMAltimeter related keys

#define kPPAltimeterIsRelativeAltitudeVailableValue @"kPPAltimeterIsRelativeAltitudeVailableValue"
#define kPPAltimeterUpdatesQueue @"kPPAltimeterUpdatesQueue"
#define kPPAltimeterUpdatesHandler @"kPPAltimeterUpdatesHandler"

#endif /* PPEventKeys_h */
