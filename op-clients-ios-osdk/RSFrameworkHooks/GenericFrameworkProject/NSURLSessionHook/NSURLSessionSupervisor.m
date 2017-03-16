//
//  NSURLSessionHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 11/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

#import "NSURLSessionSupervisor.h"
#import "JRSwizzle.h"
#import "PPAccessUnlistedHostReport.h"
#import <PPApiHooks/PPApiHooks.h>

@interface NSURLSessionSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) NSString *myHandlerIdentifier;
@end

@implementation NSURLSessionSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    PPEventDispatcher *dispatcher = [PPEventsPipelineFactory eventsDispatcher];
    if (self.myHandlerIdentifier) {
        [dispatcher removeHandlerWithIdentifier:self.myHandlerIdentifier];
    }
    
    __weak typeof(self) weakSelf = self;
    [dispatcher insertNewHandlerAtTop:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventType == EventURLSessionStartDataTaskForRequest) {
            [weakSelf processRequestEvent:event];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processRequestEvent:(PPEvent*)requestEvent {
    NSURLRequest *request = requestEvent.eventData[kPPURLSessionRequest];
    PPAccessUnlistedHostReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [requestEvent.eventData removeObjectForKey:kPPURLSessionRequest];
        [self.model.delegate newURLHostViolationReported:report];
    }
}


-(PPAccessUnlistedHostReport*)accessesUnspecifiedLink:(NSURLRequest*)request {
    NSString *host = request.URL.host;
    
    for (NSString *listedHost in self.model.scdDocument.accessedLinks) {
        if ([listedHost isEqualToString:host]) {
            return nil;
        }
    }
    
    return [[PPAccessUnlistedHostReport alloc] initWithURLHost:host reportedDate:[NSDate date]];
}

@end
