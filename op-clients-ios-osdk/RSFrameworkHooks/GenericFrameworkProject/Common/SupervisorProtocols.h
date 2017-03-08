//
//  InputSupervisorDelegate.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef InputSupervisorDelegate_h
#define InputSupervisorDelegate_h

#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>
#import "PPAccessFrequencyViolationReport.h"
#import "PPAccessUnlistedHostReport.h"
#import "PPPrivacyLevelViolationReport.h"
#import "PPUnlistedInputAccessViolation.h"

@protocol NetworkRequestAnalyzer <NSObject>
-(void)newURLRequestMade:(NSURLRequest* _Nonnull)request;
@end

@protocol InputSupervisorDelegate <NSObject>
-(void)newURLHostViolationReported:(PPAccessUnlistedHostReport* _Nonnull)report;
-(void)newPrivacyLevelViolationReported:(PPPrivacyLevelViolationReport* _Nonnull)report;
-(void)newUnlistedInputAccessViolationReported:(PPUnlistedInputAccessViolation* _Nonnull)report;
-(void)newAccessFrequencyViolationReported:(PPAccessFrequencyViolationReport* _Nonnull)report;
@end

@protocol InputSourceSupervisor <NSObject>
-(void)reportToDelegate:(id<InputSupervisorDelegate> _Nonnull)delegate analyzingSCD:(SCDDocument* _Nonnull)document;
@end

#endif /* InputSupervisorDelegate_h */
