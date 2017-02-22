//
//  OPMonitorViolationReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonReportKeys.h"

typedef NS_ENUM(NSUInteger, OPMonitorViolationType) {
    TypeUndefined,
    TypeAccessFrequencyViolation,
    TypeUnregisteredSensorAccessed,
    TypePrivacyLevelViolation,
    TypeAccessedUnlistedURL
};



@interface OPMonitorViolationReport : NSObject

@property (strong, nonatomic, readonly) NSDictionary *violationDetails;
@property (assign, nonatomic, readonly) OPMonitorViolationType violationType;
@property (strong, nonatomic, readonly) NSDate *dateReported;

-(instancetype)initWithDetails:(NSDictionary*)details violationType:(OPMonitorViolationType)type;

-(instancetype)initWithDetails:(NSDictionary*)details violationType:(OPMonitorViolationType)type date:(NSDate*)dateReported;

@end

@interface OPMonitorViolationReport(MeaningfulDescription)
-(NSString*)meaningfulDescription;
@end
