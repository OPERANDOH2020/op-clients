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
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation NSURLSessionSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    self.document = document;
    self.delegate = delegate;
}


-(void)processRequest:(NSURLRequest*)request {
    PPAccessUnlistedHostReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [self.delegate newURLHostViolationReported:report];
    }
}


-(PPAccessUnlistedHostReport*)accessesUnspecifiedLink:(NSURLRequest*)request {
    NSString *host = request.URL.host;
    
    for (NSString *listedHost in self.document.accessedLinks) {
        if ([listedHost isEqualToString:host]) {
            return nil;
        }
    }
    
    return [[PPAccessUnlistedHostReport alloc] initWithURLHost:host reportedDate:[NSDate date]];
}

@end
