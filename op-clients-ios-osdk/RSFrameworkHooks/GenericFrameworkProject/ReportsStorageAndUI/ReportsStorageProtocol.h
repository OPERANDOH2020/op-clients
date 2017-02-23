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

typedef void(^ReportsCallback)(NSArray<OPMonitorViolationReport*>* __nullable, NSError* __nullable);
typedef void(^InputTypesCallback)(NSArray<NSString*>* __nullable, NSError * __nullable);

@protocol OPViolationReportRepository <NSObject>

-(void)addReport:(OPMonitorViolationReport* __nonnull)report;
-(void)getAllReportsIn:(ReportsCallback _Nullable)completion;

-(void)clearAllReportsWithCompletion:(void(^ _Nullable)(NSError* _Nullable))completion;
-(void)deleteReport:(OPMonitorViolationReport* __nonnull)report withCompletion:(void (^ _Nullable)(NSError * _Nullable))completion;

-(void)getAllReportsOfType:(OPMonitorViolationType)type in:(ReportsCallback _Nullable)completion;
-(void)getTypesOfReportsIn:(void (^ _Nullable)(NSArray<NSNumber*> * _Nullable, NSError * _Nullable))completion;

-(void)getInputViolationReportsOfInputType:(NSString* _Nonnull)inputType in:(ReportsCallback __nullable)callback;

-(void)getCurrentInputTypesInViolationReportsIn:(InputTypesCallback __nullable)callback;
@end



#endif /* ReportsStorageProtocol_h */
