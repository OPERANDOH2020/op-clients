//
//  InputSupervisorDelegate.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef InputSupervisorDelegate_h
#define InputSupervisorDelegate_h

#import "OPMonitorViolationReport.h"
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>

@protocol InputSupervisorDelegate <NSObject>
-(void)newViolationReported:(OPMonitorViolationReport*)report;
@end

@protocol InputSourceSupervisor <NSObject>
-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument*)document;
@end

#endif /* InputSupervisorDelegate_h */
