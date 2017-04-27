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

typedef void(^PPVoidBlock)();

typedef NS_ENUM(NSInteger, PPEventType) {
    PPLocationManagerEvent,
    PPMotionManagerEvent,
    PPURLSessionEvent,
    PPDeviceProximityEvent,
    PPPedometerEvent,
    PPWKWebViewEvent,
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

typedef NS_ENUM(NSInteger, PPDeviceProximityEventType){
    EventSetDeviceProximityMonitoringEnabled,
    EventSetDeviceProximitySensingEnabled,
    EventGetDeviceProximityState
};

typedef NS_ENUM(NSInteger, PPPedometerEventType){
    EventStartPedometerUpdates
};

typedef NS_ENUM(NSInteger, PPWKWebViewEventType){
    EventAllowWebViewRequest
};


#define kConfirmationCallbackBlock @"kCommonConfirmationVoidBlock"

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



#pragma mark - 
// -

#define kPPPedometerUpdatesDateValue @"kPPPedometerUpdateDateValue"
#define kPPPedometerUpdatesHandler @"kPPPedometerUpdatesHandler"
#define kPPStartPedometerUpdatesConfirmation @"kPPStartPedometerUpdatesConfirmation"

#endif /* PPEventKeys_h */
