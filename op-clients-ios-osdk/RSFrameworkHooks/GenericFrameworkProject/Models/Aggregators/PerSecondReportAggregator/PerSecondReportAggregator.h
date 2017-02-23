//
//  PerSecondReportAggregator.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPMonitorViolationReport.h"

@interface PerSecondReportAggregator : NSObject
-(NSArray<NSArray<OPMonitorViolationReport*>*> *_Nonnull)aggregateReports:(NSArray<OPMonitorViolationReport *> * _Nonnull)reports inSecondGroupsOfLength:(NSInteger)numOfSeconds;
@end
