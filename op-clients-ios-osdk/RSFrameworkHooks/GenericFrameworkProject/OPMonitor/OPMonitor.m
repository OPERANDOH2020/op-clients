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

@interface OPMonitor()
@property (strong, nonatomic) SCDDocument *document;
@end

@implementation OPMonitor

+(instancetype)sharedInstance{
    static OPMonitor *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[OPMonitor alloc] init];
    });
    
    return  shared;
}

-(void)beginMonitoringWithAppDocument:(SCDDocument *)document {
    
    self.document = document;
    
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
