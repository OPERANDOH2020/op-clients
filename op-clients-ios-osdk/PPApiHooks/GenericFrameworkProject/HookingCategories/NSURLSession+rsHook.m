//
//  NSURLSession+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"
#import "PPEvent.h"
#import "Common.h"
#import "PPEventsPipelineFactory.h"
#import "PPEventDispatcher+Internal.h"

@interface NSURLSession(rsHook)
@end


@implementation NSURLSession(rsHook)

+(void)load {
    [self jr_swizzleMethod:@selector(dataTaskWithRequest:completionHandler:) withMethod:@selector(rsHook__dataTaskWithRequest:completionHandler:) error:nil];
}

-(NSURLSessionDataTask *)rsHook__dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    
    NSMutableDictionary *eventData = [@{
                                kPPURLSessionRequest: request
                                } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventURLSessionStartDataTaskForRequest eventData:eventData];
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSURLRequest *possiblyAlteredRequest = [eventData objectForKey:kPPURLSessionRequest];
    if (!(possiblyAlteredRequest && [possiblyAlteredRequest isKindOfClass:[NSURLRequest class]])) {
        return [self rsHook__dataTaskWithRequest:request completionHandler:completionHandler];
    }
    
    return [self rsHook__dataTaskWithRequest:possiblyAlteredRequest completionHandler:completionHandler];
}



@end
