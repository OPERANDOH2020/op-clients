//
//  CLLocationHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CLLocationHook.h"

LocationCallbackWithInfo _rsHookGlobalLocationCallback;

@interface CLLocationManager(Hook)

@end


@implementation CLLocationManager(Hook)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self jr_swizzleMethod:@selector(startUpdatingLocation) withMethod:@selector(rsHook_startUpdatingLocation) error:nil];
    }
}

-(void)rsHook_startUpdatingLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_rsHookGlobalLocationCallback) {
            _rsHookGlobalLocationCallback(@{@"status": @"startUpdatingLocation"});
        }
    });
    
    [self rsHook_startUpdatingLocation];
}

@end

@implementation CLLocationHook

+(void)hookWithCallback:(LocationCallbackWithInfo)callback{
    _rsHookGlobalLocationCallback = callback;
}

@end
