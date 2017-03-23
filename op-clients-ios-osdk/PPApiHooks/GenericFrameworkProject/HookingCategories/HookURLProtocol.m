//
//  HookURLProtocol.m
//  PPApiHooks
//
//  Created by Costin Andronache on 3/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NSURLProtocol+WKWebViewSupport.h"

#import "PPEventsPipelineFactory.h"
#import "Common.h"
#import "PPEventDispatcher+Internal.h"

@interface HookURLProtocol : NSURLProtocol
@end


@implementation HookURLProtocol

+(void)load {
    if([NSURLProtocol registerClass:[HookURLProtocol class]]){
        NSLog(@"did register HookURLProtocol class");
    }
    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
}


+(BOOL)canInitWithTask:(NSURLSessionTask *)task {
    return NO;
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPRequest, request)
    PPEvent *event = [[PPEvent alloc] initWithEventType:EventAllowRequestToExecute eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventsPipelineFactory eventsDispatcher] fireEvent:event];
    
    if ([evData objectForKey:kPPAllowRequestValue] == nil) {
        return NO;
    }
    
    return ![[evData objectForKey:kPPAllowRequestValue] boolValue];
}

-(void)startLoading {
    
}

-(void)stopLoading {
    
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return  request;
}

@end
