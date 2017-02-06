//
//  NSURLSession+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "NSURLSessionSupervisor.h"
#import "JRSwizzle.h"
#import "InputSupervisorsManager.h"


@interface NSURLSession(rsHook)

@end


@implementation NSURLSession(rsHook)

+(void)load {
    [self jr_swizzleMethod:@selector(dataTaskWithRequest:completionHandler:) withMethod:@selector(rsHook__dataTaskWithRequest:completionHandler:) error:nil];
}

-(NSURLSessionDataTask *)rsHook__dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    
    [[NSURLSession sessionInputSupervisor] processRequest:request];
    return [self rsHook__dataTaskWithRequest:request completionHandler:completionHandler];
}

+(NSURLSessionSupervisor*)sessionInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[NSURLSessionSupervisor class]];
}

@end
