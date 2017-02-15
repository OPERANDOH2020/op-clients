//
//  OPMonitorViolationReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitorViolationReport.h"

@interface OPMonitorViolationReport()
@property (strong, nonatomic, readwrite) NSString *violationDetails;
@property (assign, nonatomic, readwrite) OPMonitorViolationType violationType;
@property (strong, nonatomic, readwrite) NSDate *dateReported;

@end

@implementation OPMonitorViolationReport

-(instancetype)initWithDetails:(NSString *)details violationType:(OPMonitorViolationType)type{
    if (self = [super init]) {
        self.violationDetails = details;
        self.violationType = type;
        self.dateReported = [NSDate date];
    }
    
    return self;
}

-(instancetype)initWithDetails:(NSString*)details violationType:(OPMonitorViolationType)type date:(NSDate*)dateReported {
    
    if (self = [super init]) {
        self.violationType = type;
        self.violationDetails = details;
        self.dateReported = dateReported;
    }
    
    return self;
}
@end
