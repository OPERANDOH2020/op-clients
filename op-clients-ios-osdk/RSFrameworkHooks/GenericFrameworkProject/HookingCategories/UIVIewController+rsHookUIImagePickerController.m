//
//  UIVIewController+rsHookUIImagePickerController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "InputSupervisorsManager.h"
#import "CameraInputSupervisor.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "CommonUtils.h"
#import "JRSwizzle.h"

@interface UIViewController(rsHook_UIImagePickerController)

@end

@implementation UIViewController(rsHook_UIImagePickerController)


+(void)load {
    
    [self jr_swizzleMethod:@selector(presentViewController:animated:completion:) withMethod:@selector(rsHookUIImagePickerController_presentViewController:animated:completion:) error:nil];
    
}


-(void)rsHookUIImagePickerController_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    Class pickerClass = [UIImagePickerController class];
    
    if ([viewControllerToPresent isKindOfClass:pickerClass]) {
        UIImagePickerController *pickerVC = (UIImagePickerController*)
        viewControllerToPresent;
        
        if (pickerVC.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [[UIViewController cameraInputSupervisor] processCameraAccess];
        }
    }
    
    [self rsHookUIImagePickerController_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


+(CameraInputSupervisor*)cameraInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[CameraInputSupervisor class]];
}

@end
