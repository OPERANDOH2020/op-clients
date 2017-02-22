//
//  OPMonitorViolationReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitorViolationReport.h"

@interface OPMonitorViolationReport()
@property (strong, nonatomic, readwrite) NSDictionary *violationDetails;
@property (assign, nonatomic, readwrite) OPMonitorViolationType violationType;
@property (strong, nonatomic, readwrite) NSDate *dateReported;

@end

@implementation OPMonitorViolationReport

-(instancetype)initWithDetails:(NSDictionary *)details violationType:(OPMonitorViolationType)type{
    if (self = [super init]) {
        self.violationDetails = details;
        self.violationType = type;
        self.dateReported = [NSDate date];
    }
    
    return self;
}

-(instancetype)initWithDetails:(NSDictionary*)details violationType:(OPMonitorViolationType)type date:(NSDate*)dateReported {
    
    if (self = [super init]) {
        self.violationType = type;
        self.violationDetails = details;
        self.dateReported = dateReported;
    }
    
    return self;
}
@end



@implementation OPMonitorViolationReport(MeaningfulDescription)

-(NSString *)meaningfulDescription {
    NSString *description = nil;
    
    if (self.violationType == TypeAccessedUnlistedURL) {
        description = [NSString stringWithFormat:@"Accessed unlisted host: %@", self.violationDetails[kURLReportKey]];
    }
    
    if (self.violationType == TypeUnregisteredSensorAccessed) {
        description = [NSString stringWithFormat:@"Accessed unlisted input: %@", self.violationDetails[kInputTypeReportKey]];
    }
    
    return description;
}

@end
