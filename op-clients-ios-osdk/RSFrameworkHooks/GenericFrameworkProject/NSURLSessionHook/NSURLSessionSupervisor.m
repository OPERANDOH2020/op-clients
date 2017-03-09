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

@interface NSURLSessionSupervisor()
@property (strong, nonatomic) NSArray<id<NetworkRequestAnalyzer>> *requestAnalyzers;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation NSURLSessionSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
}



-(void)reportRequestsToAnalyzers:(NSArray<id<NetworkRequestAnalyzer>> *)analyzers {
    self.requestAnalyzers = analyzers;
}

-(void)processRequest:(NSURLRequest*)request {
    PPAccessUnlistedHostReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [self.model.delegate newURLHostViolationReported:report];
    }
    
    for (id<NetworkRequestAnalyzer> analyzer in self.requestAnalyzers) {
        [analyzer newURLRequestMade:request];
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
