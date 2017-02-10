//
//  PPFlowBuilder.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI-Swift.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>
#import "ReportsStorageProtocol.h"


@interface PPFlowBuilderModel : NSObject

@property (strong, nonatomic) id<SCDRepository> scdRepository;
@property (strong, nonatomic) id<OPViolationReportRepository> violationReportsRepository;
@property (strong, nonatomic) void (^onExitCallback)();


@end


@interface PPFlowBuilder : NSObject

-(UIViewController*)buildFlowWithModel:(PPFlowBuilderModel*)model;

@end
