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

@implementation PPFlowBuilderModel

@end

@interface PPFlowBuilder ()

@end

@implementation PPFlowBuilder

-(UIViewController *)buildFlowWithModel:(PPFlowBuilderModel *)model {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PPViews" bundle:[NSBundle bundleForClass:[self class]]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBarHidden = true;
    
    __weak UINavigationController *weakNavgController = navigationController;
    
    UIPPOptionsViewController *optionsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIPPOptionsViewController"];
    
    UIViolationReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIViolationReportsViewController"];
    
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
    
    callbacks.whenExiting = model.onExitCallback;
    
    [optionsVC setupWithCallbacks:callbacks];
    
    navigationController.viewControllers = @[optionsVC];
    
    return navigationController;
}

@end
