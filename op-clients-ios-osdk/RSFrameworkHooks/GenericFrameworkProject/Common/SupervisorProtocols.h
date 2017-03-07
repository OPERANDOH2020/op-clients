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

@protocol InputSupervisorDelegate <NSObject>
-(void)newURLHostViolationReported:(PPAccessUnlistedHostReport*)report;
-(void)newPrivacyLevelViolationReported:(PPPrivacyLevelViolationReport*)report;
-(void)newUnlistedInputAccessViolationReported:(PPUnlistedInputAccessViolation*)report;
-(void)newAccessFrequencyViolationReported:(PPAccessFrequencyViolationReport*)report;
@end

@protocol InputSourceSupervisor <NSObject>
-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument*)document;
@end

#endif /* InputSupervisorDelegate_h */
