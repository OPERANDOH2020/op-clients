//
//  LocationInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSupervisor.h"
#import <CoreLocation/CoreLocation.h>
#import <JRSwizzle.h>

typedef void (^LocationCallbackWithInfo)(NSDictionary*);
LocationCallbackWithInfo _rsHookGlobalLocationCallback;

static const NSString *kStatusKey = @"status";

typedef enum : NSUInteger {
    Undefined,
    StartUpdatingLocation,
    RequestAlwaysAuthorization,
    RequestWhenInUseAuthorization
} LocationStatus;


@interface CLLocationManager(Hook)

@end


@implementation CLLocationManager(Hook)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self jr_swizzleMethod:@selector(startUpdatingLocation) withMethod:@selector(rsHook_startUpdatingLocation) error:nil];
        
        [self jr_swizzleMethod:@selector(requestAlwaysAuthorization) withMethod:@selector(rsHook_requestAlwaysAuthorization) error:nil];
        
        [self jr_swizzleMethod:@selector(requestWhenInUseAuthorization) withMethod:@selector(rsHook_requestWhenInUseAuthorization) error:nil];
        
    } else {
    }
}

-(void)rsHook_startUpdatingLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(_rsHookGlobalLocationCallback, @{kStatusKey: @(StartUpdatingLocation)})
    });
    
    [self rsHook_startUpdatingLocation];
}

-(void)rsHook_requestAlwaysAuthorization {
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(_rsHookGlobalLocationCallback, @{kStatusKey: @(RequestAlwaysAuthorization)})
    });
    
    [self rsHook_requestAlwaysAuthorization];
}


-(void)rsHook_requestWhenInUseAuthorization{
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(_rsHookGlobalLocationCallback, @{kStatusKey: @(RequestWhenInUseAuthorization)})
    });
    
    
    [self rsHook_requestWhenInUseAuthorization];
}


@end

@interface LocationInputSupervisor()
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedSensor *locationSensor;
@end


@implementation LocationInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    self.delegate = delegate;
    self.document = document;
    self.locationSensor = [LocationInputSupervisor extractLocationSensorFrom:document];
    
    __weak LocationInputSupervisor *weakSelf = self;
    _rsHookGlobalLocationCallback = ^(NSDictionary *dict){
        [weakSelf processStatusDict:dict];
    };
}


-(void)processStatusDict:(NSDictionary*)dict {
    if (dict[kStatusKey]) {
        [self processStatus:[dict[kStatusKey] integerValue]];
    }
}

-(void)processStatus:(LocationStatus)locStatus {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUsesLocationWhenNotEvenSpecified:locStatus])) {
        [self.delegate newViolationReported:report];
    }
}


+(AccessedSensor*)extractLocationSensorFrom:(SCDDocument*)document{
    for (AccessedSensor *sensor in document.accessedSensors) {
        if ([sensor.sensorType isEqualToString:SensorType.Location]) {
            return sensor;
        }
    }
    
    return  nil;
}


-(OPMonitorViolationReport*)detectUsesLocationWhenNotEvenSpecified:(LocationStatus)status {
    if (self.locationSensor) {
        return nil;
    }
    
    if (status == RequestAlwaysAuthorization || status == RequestWhenInUseAuthorization) {
        NSString *message = @"The app accesses the location APIs even though the self-compliance document does not specify using the location!";
        return [[OPMonitorViolationReport alloc] initWithDetails:message violationType:TypeUnregisteredSensorAccessed];
    
    }
    
    return nil;
}

@end
