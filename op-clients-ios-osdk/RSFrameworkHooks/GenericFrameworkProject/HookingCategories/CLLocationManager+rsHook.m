//
//  CLLocationManager+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "InputSupervisorsManager.h"
#import "LocationInputSupervisor.h"
#import "JRSwizzle.h"

@interface CLLocationManager(Hook)

@end


@implementation CLLocationManager(Hook)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self jr_swizzleMethod:@selector(startUpdatingLocation) withMethod:@selector(rsHook_startUpdatingLocation) error:nil];
        
        [self jr_swizzleMethod:@selector(requestAlwaysAuthorization) withMethod:@selector(rsHook_requestAlwaysAuthorization) error:nil];
        
        [self jr_swizzleMethod:@selector(requestWhenInUseAuthorization) withMethod:@selector(rsHook_requestWhenInUseAuthorization) error:nil];
        
    }
}

-(void)rsHook_startUpdatingLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CLLocationManager locationInputSupervisor] processLocationStatus:@{kStatusKey: @(StartUpdatingLocation)}];
    });
    
    [self rsHook_startUpdatingLocation];
}

-(void)rsHook_requestAlwaysAuthorization {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CLLocationManager locationInputSupervisor] processLocationStatus:@{kStatusKey: @(RequestAlwaysAuthorization)}];
    });
    
    [self rsHook_requestAlwaysAuthorization];
}


-(void)rsHook_requestWhenInUseAuthorization{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CLLocationManager locationInputSupervisor] processLocationStatus:@{kStatusKey: @(RequestWhenInUseAuthorization)}];
    });
    
    
    [self rsHook_requestWhenInUseAuthorization];
}

+(LocationInputSupervisor*)locationInputSupervisor {
    return [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[LocationInputSupervisor class]];
}

@end
