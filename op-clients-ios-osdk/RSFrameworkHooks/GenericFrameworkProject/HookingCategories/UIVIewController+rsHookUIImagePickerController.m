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

@interface UIImagePickerController(rsHook_UIImagePickerController)

@end

@implementation UIImagePickerController(rsHook_UIImagePickerController)


+(void)load {
    
    [self jr_swizzleMethod:@selector(setSourceType:) withMethod:@selector(rsHookUIImagePickerController_setSourceType:) error:nil];
    
}

-(void)rsHookUIImagePickerController_setSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    NSLog(@"In UIImagePickerController setSourceType");
    CameraInputSupervisor *supervisor = [[self class] cameraInputSupervisor];
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [supervisor processCameraAccess];
        NSLog(@"Camera Access");
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum ||
        sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [supervisor processPhotoLibraryAccess];
        NSLog(@"Photo library access");
    }
    
    [self rsHookUIImagePickerController_setSourceType:sourceType];
}


+(CameraInputSupervisor*)cameraInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[CameraInputSupervisor class]];
}

@end
