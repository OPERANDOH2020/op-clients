//
//  PlistReportsStorage.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PlistReportsStorage.h"
#import "Common.h"

@interface OPMonitorViolationReport(PlistReportsSerialize)

-(NSDictionary*)plistRepository_toPlistDictionary;
+(OPMonitorViolationReport*)plistRepository_fromPlistDictionary:(NSDictionary*)dict;

@end


@implementation OPMonitorViolationReport(PlistReportsSerialize)

-(NSDictionary *)plistRepository_toPlistDictionary{
    return @{
              @"details": self.violationDetails,
              @"type": @(self.violationType),
              @"date": self.dateReported
              };
}

+(OPMonitorViolationReport *)plistRepository_fromPlistDictionary:(NSDictionary *)dict {
    
    NSString *details = dict[@"details"];
    NSNumber *type = dict[@"type"];
    NSDate *date = dict[@"date"];
    
    if (details && type && date) {
        return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:type.integerValue date:date];
    }
    
    return nil;
}

@end



@interface PlistReportsStorage()

@property (strong, nonatomic) NSMutableArray *reportsArray;

@end

@implementation PlistReportsStorage

static const NSString *kPlistReportStorageDomain = @"com.plistReportStorage";
static const NSString *kIndexOutOfRangeDescription = @"Index is out of range";
static const NSString *kObjectNotInRepository = @"Object is not in repository";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reportsArray = [PlistReportsStorage buildFromPlist];
        
    }
    return self;
}

-(void)addReport:(OPMonitorViolationReport *)report{
    if (report) {
        [self.reportsArray addObject:report];
        [self synchronize];
    }
}


-(void)clearAllReportsWithCompletion:(void (^)(NSError *))completion {
    [self.reportsArray removeAllObjects];
    [self synchronize];
    SAFECALL(completion, nil)
}


-(void)deleteReport:(OPMonitorViolationReport *)report withCompletion:(void (^)(NSError *))completion {
    
    NSError *error = nil;
    if (! [self.reportsArray containsObject:report]) {
        error = [NSError errorWithDomain:kPlistReportStorageDomain code:TypeObjectNotInRepository userInfo:@{NSLocalizedDescriptionKey: kObjectNotInRepository}];
    } else {
        [self.reportsArray removeObject:report];
    }
    
    SAFECALL(completion, error)
}

-(void)getAllReportsIn:(void (^)(NSArray<OPMonitorViolationReport *> * _Nullable, NSError * _Nullable))completion {
    
    SAFECALL(completion, self.reportsArray, nil)
}

#pragma mark - private methods


-(void)synchronize {
    NSMutableArray<NSDictionary*> *dictsArray = [[NSMutableArray alloc] init];
    [dictsArray writeToFile:[PlistReportsStorage plistPath] atomically:YES];
}



+(NSMutableArray<OPMonitorViolationReport*> *)buildFromPlist {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *dicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPath]];
    
    for (NSDictionary *dict in dicts) {
        OPMonitorViolationReport *report = [OPMonitorViolationReport plistRepository_fromPlistDictionary:dict];
        
        if (report) {
            [result addObject:report];
        }
    }
    
    return result;
}

+(NSString*)plistPath {
    
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    
    if (paths.firstObject) {
        return [paths.firstObject stringByAppendingPathComponent:@"MonitorViolationReportPlist.plist"];
    }
    
    return @"";
}

@end

