//
//  OPMonitor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitor.h"

#import "CLLocationHook.h"
#import "NSURLSessionHook.h"

@implementation OPMonitor

+(void)beginMonitoringWithAppDocument:(SCDDocument *)document {
    [NSURLSessionHook hookWithCallback:^(NSURLRequest *request) {
        NSLog(@"Made the following request %@", request);
    }];
    
    [CLLocationHook hookWithCallback:^(NSDictionary *info) {
        NSLog(@"Location status %@", info);
    }];
}

+(void)beginMonitoring {

}

@end
