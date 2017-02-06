//
//  ReportsStorageProtocol.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef ReportsStorageProtocol_h
#define ReportsStorageProtocol_h

#import "OPMonitorViolationReport.h"


@protocol OPViolationReportRepository <NSObject>

-(void)addReport:(OPMonitorViolationReport* __nonnull)report;
-(void)getAllReportsIn:( void(^ _Nullable )(NSArray<OPMonitorViolationReport*>* __nullable, NSError* __nullable))completion;

-(void)clearAllReportsWithCompletion:(void(^)(NSError*))completion;
-(void)deleteReportAtIndex:(NSInteger)index withCompletion:(void (^)(NSError *))completion;

@end

#endif /* ReportsStorageProtocol_h */
