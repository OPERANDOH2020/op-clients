//
//  OPMonitorViolationReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OPMonitorViolationType) {
    TypeUndefined,
    TypeAccessFrequencyViolation,
    TypeUnregisteredSensorAccessed,
    TypePrivacyLevelViolation,
    TypeAccessedUnlistedURL
};

@interface OPMonitorViolationReport : NSObject

@property (strong, nonatomic, readonly) NSString *violationDetails;
@property (assign, nonatomic, readonly) OPMonitorViolationType violationType;
@property (strong, nonatomic, readonly) NSDate *dateReported;

-(instancetype)initWithDetails:(NSString*)details violationType:(OPMonitorViolationType)type;

-(instancetype)initWithDetails:(NSString*)details violationType:(OPMonitorViolationType)type date:(NSDate*)dateReported;

@end
