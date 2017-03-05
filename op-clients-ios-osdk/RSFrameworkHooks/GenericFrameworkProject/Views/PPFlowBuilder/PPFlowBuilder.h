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
#import "OPMonitorSettings.h"
#import "UILocationSettingsViewController.h"
#import "PPReportsSourcesBundle.h"



@interface PPFlowBuilderModel : NSObject

@property (strong, nonatomic) OPMonitorSettings *monitoringSettings;
@property (strong, nonatomic) NSDictionary *scdJSON;
@property (strong, nonatomic) id<SCDRepository> scdRepository;
@property (strong, nonatomic) PPReportsSourcesBundle *reportSources;
@property (strong, nonatomic) void (^onExitCallback)();

@property (strong, nonatomic) LocationSettingsModel *locationSettingsModel;

@end


@interface PPFlowBuilder : NSObject

-(UIViewController*)buildFlowWithModel:(PPFlowBuilderModel*)model;

@end
