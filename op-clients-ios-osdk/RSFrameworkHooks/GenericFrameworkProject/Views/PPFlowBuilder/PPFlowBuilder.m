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
    
    UIViolationReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIViolationReportsViewController"];
    
    UISCDViewController *scdVC = [storyboard instantiateViewControllerWithIdentifier:@"UISCDViewController"];
    
    [scdVC setupWithSCD:model.scdJSON onClose:^{
        [weakNavgController popViewControllerAnimated:true];
    }];
    
    [reportsVC setupWithRepository:model.violationReportsRepository onExit:^{
        [weakNavgController popViewControllerAnimated:true];
    }];
    
    UIViewController *commonUIVC = [CommonUIBUilder buildFlowFor:model.scdRepository whenExiting:^{
        [weakNavgController popViewControllerAnimated:true];
    }];
    
    
    UIViewController *commonUIIncapsulator = [[UIEncapsulatorViewController alloc] init];
    [commonUIIncapsulator ppAddChildContentController:commonUIVC];
    
    UIPPOptionsViewControllerCallbacks *callbacks = [[UIPPOptionsViewControllerCallbacks alloc] init];
    
    callbacks.whenChoosingSCDInfo = ^{
        [weakNavgController pushViewController:commonUIIncapsulator animated:true];
    };
    
    callbacks.whenChoosingReportsInfo = ^{
        [weakNavgController pushViewController:reportsVC animated:true];
    };
    
    callbacks.whenChoosingViewSCD = ^{
        [weakNavgController pushViewController:scdVC animated:true];
    };
    
    callbacks.whenExiting = model.onExitCallback;
    
    [optionsVC setupWithCallbacks:callbacks];
    
    navigationController.viewControllers = @[optionsVC];
    
    return navigationController;
}

@end
