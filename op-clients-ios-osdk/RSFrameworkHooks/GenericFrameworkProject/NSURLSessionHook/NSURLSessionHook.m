//
//  NSURLSessionHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 11/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

#import "NSURLSessionHook.h"
#import "JRSwizzle.h"

URLRequestHookCallback _urlRequestHookCallback;

@interface NSURLSession(Hook)

@end


@implementation NSURLSession(Hook)

+(void)load{
    [self jr_swizzleMethod:@selector(dataTaskWithRequest:completionHandler:) withMethod:@selector(rsHook__dataTaskWithRequest:completionHandler:) error:nil];
}

-(NSURLSessionDataTask *)rsHook__dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_urlRequestHookCallback) {
            _urlRequestHookCallback(request);
        }
    });
    
    return [self rsHook__dataTaskWithRequest:request completionHandler:completionHandler];
}

@end

@implementation NSURLSessionHook

+(void)hookWithCallback:(URLRequestHookCallback)callback{
    _urlRequestHookCallback = callback;
}

@end
