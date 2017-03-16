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

@interface NullUrlSessionDataTask : NSURLSessionDataTask
@end

@implementation NullUrlSessionDataTask

-(void)resume {
}

-(void)cancel {
}

-(void)suspend {
}

@end

@interface NSURLSession(rsHook)
@end


@implementation NSURLSession(rsHook)

+(void)load {
    [self jr_swizzleMethod:@selector(dataTaskWithRequest:completionHandler:) withMethod:@selector(rsHook__dataTaskWithRequest:completionHandler:) error:nil];
}


/*
 Convention:
  - The parameters sent are:
    --1. The NSURLRequest
    --2. The completionHandler
 
  - Upon returning, the code expects that an object of type NSURLRequest is present at the required key. If so, it calls the real API method to create a dataTask object and returns it. If not, then an empty dataTask object is created and returned.
 
  // must continue with more swizzled implementations
 */

-(NSURLSessionDataTask *)rsHook__dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    
    NSMutableDictionary *eventData = [@{} mutableCopy];
    if (request) {
        [eventData setObject:request forKey:kPPURLSessionRequest];
    }
    
    if (completionHandler) {
        [eventData setObject:completionHandler forKey:kPPURLSessionCompletionHandler];
    }
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventURLSessionStartDataTaskForRequest eventData:eventData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSURLRequest *possiblyAlteredRequest = [eventData objectForKey:kPPURLSessionRequest];
    if (!(possiblyAlteredRequest && [possiblyAlteredRequest isKindOfClass:[NSURLRequest class]])) {
        
        return [[NullUrlSessionDataTask alloc] init];
    }
    
    return [self rsHook__dataTaskWithRequest:possiblyAlteredRequest completionHandler:completionHandler];
}



@end
