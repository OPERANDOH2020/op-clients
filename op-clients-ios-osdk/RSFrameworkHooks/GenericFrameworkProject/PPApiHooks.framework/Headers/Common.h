//
//  PPEventKeys.h
//  PPApiHooks
//
//  Created by Costin Andronache on 3/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef PPEventKeys_h
#define PPEventKeys_h

#define SAFECALL(x, ...) if(x){x(__VA_ARGS__);}


typedef NS_ENUM(NSInteger, PPEventType) {
    EventLocationManagerStartLocationUpdates,
    EventLocationManagerRequestAlwaysAuthorization,
    EventLocationManagerRequestWhenInUseAuthorization,
    EventLocationManagerSetDelegate,
    EventLocationManagerGetCurrentLocation,
    
    EventURLSessionStartDataTaskForRequest,
    EventMotionManagerStartAccelerometerUpdates,
    EventMotionManagerStartMagnetometerUpdates,
    EventMotionManagerStartDeviceMotionUpdates,
    EventSetDeviceProximityMonitoringEnabled,
    EventSetDeviceProximitySensingEnabled,
    EventGetDeviceProximityState,
    
    EventStartPedometerUpdates,
    EventAllowRequestToExecute

};

#import <Foundation/Foundation.h>

#pragma mark - 

#define kPPRequest @"kPPRequest"
#define kPPAllowRequestValue @"kPPAllowRequestValue"

// - NSURLSession related keys

#define kPPURLSessionDataTask @"kURLSessionDataTask"
#define kPPURLSessionDataTaskRequest @"kPPURLSessionDataTaskRequest"
#define kPPURLSessionDataTaskResponse @"kPPURLSessionDataTaskResponse"
#define kPPURLSessionDatTaskResponseData @"kPPURLSessionDatTaskResponseData"
#define kPPURLSessionDataTaskError @"kPPURLSessionDataTaskError"

#pragma mark - 
// - CLLocationManager related keys

#define kPPStartLocationUpdatesConfirmation @"kPPStartLocationUpdatesConfirmationKey"
#define kPPRequestAlwaysAuthorizationConfirmation @"kPPRequestAlwaysAuthorizationConfirmation"
#define kPPRequestWhenInUseAuthorizationConfirmation @"kPPRequestWhenInUseAuthorizationConfirmation"


#define kPPLocationManagerDelegate @"kPPLocationManagerDelegate"
#define kPPLocationManagerInstance @"kPPLocationManagerInstance"
#define kPPLocationManagerSetDelegateConfirmation @"kPPLocationManagerSetDelegateConfirmation"

#define kPPLocationManagerGetCurrentLocationValue @"kPPLocationManagerGetCurrentLocationValue"

#pragma mark - 
// - CMMotionManager related keys

#define kPPStartAccelerometerUpdatesConfirmation @"kPPStartAccelerometerUpdatesConfirmation"
#define kPPStartDeviceMotionUpdatesConfirmation @"kPPStartDeviceMotionUpdatesConfirmation"
#define kPPStartMagnetometerUpdatesConfirmation @"kPPStartMagnetometerUpdatesConfirmation"

#pragma mark - 
// - UIDevice & proximity related keys

#define kPPDeviceProximityMonitoringEnabledValue @"kPPDeviceProximityMonitoringEnabledValue"
#define kPPDeviceProximitySensingEnabledValue @"kPPDeviceProximitySensingEnabledValue"
#define kPPDeviceProxmityStateValue @"kPPDeviceProxmityStateValue"



#pragma mark - 
// -

#define kPPPedometerUpdatesDateValue @"kPPPedometerUpdateDateValue"
#define kPPPedometerUpdatesHandler @"kPPPedometerUpdatesHandler"
#define kPPStartPedometerUpdatesConfirmation @"kPPStartPedometerUpdatesConfirmation"




#define SAFEADD(dict, key, value) if(value){[dict setObject:value forKey:key];}

typedef void(^PPVoidBlock)();

#endif /* PPEventKeys_h */
