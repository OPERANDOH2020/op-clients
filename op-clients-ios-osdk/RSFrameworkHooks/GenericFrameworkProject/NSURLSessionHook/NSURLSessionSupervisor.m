//
//  NSURLSessionHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 11/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

#import "NSURLSessionSupervisor.h"
#import "JRSwizzle.h"

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
    OPMonitorViolationReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)accessesUnspecifiedLink:(NSURLRequest*)request {
    
    OPMonitorViolationType violationType = TypeAccessedUnlistedURL;
    OPMonitorViolationReport *report = nil;
    NSString *host = request.URL.host;
    
    for (NSString *listedHost in self.document.accessedLinks) {
        if ([listedHost isEqualToString:host]) {
            return nil;
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"The app accesses the host:\n%@\nbut the host isn't specified in the self-compliance document!", host];
    report = [[OPMonitorViolationReport alloc] initWithDetails:message violationType:violationType];
    return report;
}

@end
