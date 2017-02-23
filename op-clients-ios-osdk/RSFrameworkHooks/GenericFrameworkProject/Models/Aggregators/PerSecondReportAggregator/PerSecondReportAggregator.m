//
//  PerSecondReportAggregator.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PerSecondReportAggregator.h"

@implementation PerSecondReportAggregator

-(NSArray<NSArray<OPMonitorViolationReport*>*> *_Nonnull)aggregateReports:(NSArray<OPMonitorViolationReport *> * _Nonnull)reports inSecondGroupsOfLength:(NSInteger)numOfSeconds {
    
    if (reports.count == 1) {
        return @[reports];
    }
    
    NSArray *sortedReportsByDate = [reports sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        OPMonitorViolationReport *a = obj1, *b = obj2;
        return [a.dateReported compare:b.dateReported];
        
    }];
    
    
    OPMonitorViolationReport *first = sortedReportsByDate.firstObject;
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSInteger currentArrayIndex = 0;
    NSDate *maxDateForCurrentSecond = [first.dateReported dateByAddingTimeInterval:numOfSeconds];
    
    while (currentArrayIndex < sortedReportsByDate.count) {
        
        NSMutableArray *itemsForCurrentGroup = [[NSMutableArray alloc] init];
        BOOL keepScanningForCurrentDate = YES;

        while (currentArrayIndex < sortedReportsByDate.count && keepScanningForCurrentDate) {
            OPMonitorViolationReport *report = sortedReportsByDate[currentArrayIndex];
            NSComparisonResult comparisonResult = [report.dateReported compare:maxDateForCurrentSecond];
            if (comparisonResult == NSOrderedSame || comparisonResult == NSOrderedAscending) {
                [itemsForCurrentGroup addObject:report];
                currentArrayIndex++;
            } else {
                keepScanningForCurrentDate = NO;
            }
        }
        
        [result addObject:itemsForCurrentGroup];
        if (currentArrayIndex < sortedReportsByDate.count) {
            OPMonitorViolationReport *unprocessedReport = sortedReportsByDate[currentArrayIndex];
            maxDateForCurrentSecond = [unprocessedReport.dateReported dateByAddingTimeInterval:numOfSeconds];
        }
    }
    
    
    return result;
}

@end
