//
//  PPEventKeys.h
//  PPApiHooks
//
//  Created by Costin Andronache on 3/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef PPEventKeys_h
#define PPEventKeys_h


typedef NS_ENUM(NSInteger, PPEventType) {
    EventLocationManagerStartLocationUpdates,
    EventLocationManagerRequestAlwaysAuthorization,
    EventLocationManagerRequestWhenInUseAuthorization,
    EventURLSessionStartDataTaskForRequest,
    EventMotionManagerStartAccelerometerUpdates,
    EventMotionManagerStartMagnetometerUpdates,
    EventMotionManagerStartDeviceMotionUpdates
};

#import <Foundation/Foundation.h>

#define kPPURLSessionDataTask @"kURLSessionDataTaskKey"
#define kPPURLSessionRequest @"kPPURLSessionRequestKey"
#define kPPStartLocationUpdatesConfirmation @"kPPStartLocationUpdatesConfirmationKey"

#define kPPRequestAlwaysAuthorizationConfirmation @"kPPRequestAlwaysAuthorizationConfirmation"

#define kPPRequestWhenInUseAuthorizationConfirmation @"kPPRequestWhenInUseAuthorizationConfirmation"

#define kPPStartAccelerometerUpdatesConfirmation @"kPPStartAccelerometerUpdatesConfirmation"

#define kPPStartDeviceMotionUpdatesConfirmation @"kPPStartDeviceMotionUpdatesConfirmation"


#define kPPStartMagnetometerUpdatesConfirmation @"kPPStartMagnetometerUpdatesConfirmation"

typedef void(^PPVoidBlock)();

#endif /* PPEventKeys_h */
