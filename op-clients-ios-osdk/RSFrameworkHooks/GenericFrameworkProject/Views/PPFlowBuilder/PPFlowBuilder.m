//
//  PPFlowBuilder.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPFlowBuilder.h"
#import "ReportsStorageProtocol.h"
#import "UIViolationReportsViewController.h"
#import "UIPPOptionsViewController.h"
#import "UIEncapsulatorViewController.h"
#import "UISCDViewController.h"
#import "NSBundle+RSFrameworkHooks.h"



@implementation PPFlowBuilderModel
@end

@interface PPFlowBuilder ()
@end

@implementation PPFlowBuilder

-(UIViewController *)buildFlowWithModel:(PPFlowBuilderModel *)model {
    
    NSBundle *bundle = [NSBundle frameworkHooksBundle];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PPViews" bundle:bundle];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBarHidden = true;
    
    __weak UINavigationController *weakNavgController = navigationController;
    
    UIPPOptionsViewController *optionsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIPPOptionsViewController"];
    
    UIPPOptionsViewControllerCallbacks *callbacks = [[UIPPOptionsViewControllerCallbacks alloc] init];
    
    callbacks.whenChoosingSCDInfo = ^{
        UIViewController *commonUIVC = [CommonUIBUilder buildFlowFor:model.scdRepository whenExiting:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
    
        UIViewController *commonUIIncapsulator = [[UIEncapsulatorViewController alloc] init];
        [commonUIIncapsulator ppAddChildContentController:commonUIVC];
        
        [weakNavgController pushViewController:commonUIIncapsulator animated:true];
    };
    
    callbacks.whenChoosingReportsInfo = ^{
        UIViolationReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIViolationReportsViewController"];
        [reportsVC setupWithRepository:model.violationReportsRepository onExit:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
        [weakNavgController pushViewController:reportsVC animated:true];
    };
    
    callbacks.whenChoosingViewSCD = ^{
        UISCDViewController *scdVC = [storyboard instantiateViewControllerWithIdentifier:@"UISCDViewController"];
        
        [scdVC setupWithSCD:model.scdJSON onClose:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
        
        [weakNavgController pushViewController:scdVC animated:true];
    };
    
    callbacks.whenChoosingOverrideLocation = ^{
        UILocationSettingsViewController *locSettingsVC = [storyboard instantiateViewControllerWithIdentifier:@"UILocationSettingsViewController"];
        [locSettingsVC setupWithModel:model.locationSettingsModel onExit:^{
            [weakNavgController popViewControllerAnimated:YES];
        }];
        [weakNavgController pushViewController:locSettingsVC animated:YES];
    };
    
    callbacks.whenExiting = model.onExitCallback;
    
    [optionsVC setupWithCallbacks:callbacks andMonitorSettings:model.monitoringSettings];
    
    navigationController.automaticallyAdjustsScrollViewInsets = NO;
    navigationController.viewControllers = @[optionsVC];
    
    return navigationController;
}

@end
