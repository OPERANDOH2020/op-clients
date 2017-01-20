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
@end

@implementation OPMonitorViolationReport

-(instancetype)initWithDetails:(NSString *)details violationType:(OPMonitorViolationType)type{
    if (self = [super init]) {
        self.violationDetails = details;
        self.violationType = type;
    }
    
    return self;
}

@end
