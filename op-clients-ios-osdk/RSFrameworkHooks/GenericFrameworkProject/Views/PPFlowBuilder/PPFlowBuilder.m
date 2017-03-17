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
#import "UIUsageViewController.h"
#import "UIInputGraphViewController.h"

@implementation PPFlowBuilderModel
@end

@interface PPFlowBuilder ()
@end

@implementation PPFlowBuilder

-(UIViewController *)buildFlowWithModel:(PPFlowBuilderModel *)model {
    
    NSBundle *bundle = [NSBundle PPCloakBundle];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PPViews" bundle:bundle];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBarHidden = true;
    
    __weak UINavigationController *weakNavgController = navigationController;
    
    UIPPOptionsViewController *optionsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIPPOptionsViewController"];
    
    UIPPOptionsViewControllerCallbacks *callbacks = [[UIPPOptionsViewControllerCallbacks alloc] init];
    
    callbacks.whenChoosingSCDInfo = ^{
        UIViewController *commonUIVC = [CommonUIBUilder buildFlowFor:model.scdRepository exitArrowDirection:ExitArrowDirectionLeft whenExiting:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
    
        UIViewController *commonUIIncapsulator = [[UIEncapsulatorViewController alloc] init];
        [commonUIIncapsulator ppAddChildContentController:commonUIVC];
        
        [weakNavgController pushViewController:commonUIIncapsulator animated:true];
    };
    
    callbacks.whenChoosingReportsInfo = ^{
        UIViolationReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIViolationReportsViewController"];
        [reportsVC setupWithReportSources:model.reportSources onExit:^{
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
    
    callbacks.whenChoosingUsageGraphs = ^{
        
        void (^displayGraphWithReports)(NSArray<BaseReportWithDate*>*) = ^void(NSArray<BaseReportWithDate*> *reports){
            UIGraphViewController *graphVC = [storyboard instantiateViewControllerWithIdentifier:@"UIGraphViewController"];
            
            [graphVC setupWithReports:reports exitCallback:^{
                [weakNavgController popViewControllerAnimated:YES];
            }];
            
            [weakNavgController pushViewController:graphVC animated:YES];
            
        };
        
        [model.reportSources.unlistedHostReportsSource getUnlistedHostReportsIn:^(NSArray<PPAccessUnlistedHostReport *> * _Nullable hostReports, NSError * _Nullable hostReportsError) {
            
            [model.reportSources.unlistedInputReportsSource getCurrentInputTypesInViolationReportsIn:^(NSArray<InputType *> * _Nullable inputTypes, NSError * _Nullable inputTypesError) {
                
                
                UIUsageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UIUsageViewController"];
                
                UIUsageViewControllerModel *usageModel = [[UIUsageViewControllerModel alloc] init];
                usageModel.displayNetworkReportsOption = hostReports.count > 0;
                usageModel.inputTypesOptions = inputTypes;
                
                UIUsageViewControllerCallbacks *callbacks = [[UIUsageViewControllerCallbacks alloc] init];
                callbacks.exitCallback = ^{
                    [weakNavgController popViewControllerAnimated:YES];
                };
                
                callbacks.inputTypeSelectedCallback = ^void(InputType* inputType){
                    
                    [model.reportSources.unlistedInputReportsSource getViolationReportsOfInputType:inputType in:^(NSArray<PPUnlistedInputAccessViolation *> * _Nullable reports, NSError * _Nullable error) {
                        displayGraphWithReports(reports);
                    }];
                    
                };
                
                callbacks.networkReportsSelectedCallback = ^{
                    displayGraphWithReports(hostReports);
                };
                
                [vc setupWithModel:usageModel andCallbacks:callbacks];
                [weakNavgController pushViewController:vc animated:YES];
                
            }];
            
        }];
        
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
