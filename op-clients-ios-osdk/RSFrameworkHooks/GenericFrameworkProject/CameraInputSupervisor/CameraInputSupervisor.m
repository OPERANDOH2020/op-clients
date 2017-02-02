//
//  CameraInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CameraInputSupervisor.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "CommonUtils.h"
#import "JRSwizzle.h"



typedef void(^CameraInputCallback)();
CameraInputCallback _globalCameraInputCallback;


@interface AVCaptureDevice(rsHook_Camera)

@end

@implementation AVCaptureDevice(rsHook_Camera)

+(void)load {
    if (NSClassFromString(@"AVCaptureDevice")) {
        [self jr_swizzleClassMethod:@selector(defaultDeviceWithMediaType:) withClassMethod:@selector(rsHook_Camera_defaultDeviceWithMediaType:) error:nil];
    }
}

+(AVCaptureDevice *)rsHook_Camera_defaultDeviceWithMediaType:(NSString *)mediaType {
    
    if ([mediaType isEqualToString:AVMediaTypeVideo]) {
        SAFECALL(_globalCameraInputCallback)
    }
    
    return [self rsHook_Camera_defaultDeviceWithMediaType:mediaType];
}

@end

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
            SAFECALL(_globalCameraInputCallback)
        }
    }
    
    [self rsHookUIImagePickerController_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end

@interface CameraInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *cameraSensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation CameraInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.document = document;
    self.delegate = delegate;
    self.cameraSensor = [CommonUtils extractInputOfType: InputType.Camera from:document.accessedInputs];
    
    __weak typeof(self) weakSelf = self;
    _globalCameraInputCallback = ^void() {
        [weakSelf processCameraAccess];
    };
}

-(void)processCameraAccess {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}

-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.cameraSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app accesses the camera even though it is not specified in the self-compliance document" violationType:TypeUnregisteredSensorAccessed];
}

@end
