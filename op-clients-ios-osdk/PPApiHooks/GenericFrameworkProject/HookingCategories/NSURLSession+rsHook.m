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
@property (weak, nonatomic) NSURLSession *weakSession;
@end

@implementation NullUrlSessionDataTask

-(instancetype)initWithSession:(NSURLSession*)session {
    if (self = [super init]) {
        self.weakSession = session;
    }
    return self;
}

-(void)resume {
}

-(void)cancel {
}

-(void)suspend {
}

-(NSURLSessionTaskState)state {
    
    return NSURLSessionTaskStateSuspended;
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
 
  - Upon returning, the code checks for the existence of a NSURLResponse or a NSError and optionally a NSData object. If these are present, then an empty dataTask is returned followed by calling the completion handler (in an async block) with the provided objects. Else, the default behaviour is invoked.
 */

-(NSURLSessionDataTask *)rsHook__dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    
    NSMutableDictionary *eventData = [@{} mutableCopy];
    SAFEADD(eventData, kPPURLSessionDataTaskRequest, request)
    
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventURLSessionStartDataTaskForRequest eventData:eventData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    NSURLResponse *response = eventData[kPPURLSessionDataTaskResponse];
    NSData *data = eventData[kPPURLSessionDatTaskResponseData];
    NSError *error = eventData[kPPURLSessionDataTaskError];
    
    if (response || error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SAFECALL(completionHandler, data, response, error)
        });
        return [[NullUrlSessionDataTask alloc] init];
    }
    
    return [self rsHook__dataTaskWithRequest:request completionHandler:completionHandler];
}

@end




