//
//  LocationInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"
#import "Common.h"
#import "LocationInputSwizzler.h"

static const NSString *kStatusKey = @"status";

typedef enum : NSUInteger {
    Undefined,
    StartUpdatingLocation,
    RequestAlwaysAuthorization,
    RequestWhenInUseAuthorization
} LocationStatus;


@interface LocationInputSupervisor : NSObject <InputSourceSupervisor, LocationInputAnalyzer>

-(void)processLocationStatus:(NSDictionary*)statusDict;

@end
