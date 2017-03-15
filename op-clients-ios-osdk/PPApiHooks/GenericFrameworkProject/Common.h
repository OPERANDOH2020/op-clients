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
    EventGetDeviceProximityState
};

#import <Foundation/Foundation.h>

#pragma mark - 
// - NSURLSession related keys

#define kPPURLSessionDataTask @"kURLSessionDataTaskKey"
#define kPPURLSessionRequest @"kPPURLSessionRequestKey"
#define kPPURLSessionCompletionHandler @"kPPURLSessionCompletionHandler"

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
// -

#define kPPDeviceProximityMonitoringEnabledValue @"kPPDeviceProximityMonitoringEnabledValue"
#define kPPDeviceProximitySensingEnabledValue @"kPPDeviceProximitySensingEnabledValue"
#define kPPDeviceProxmityStateValue @"kPPDeviceProxmityStateValue"


typedef void(^PPVoidBlock)();

#endif /* PPEventKeys_h */
