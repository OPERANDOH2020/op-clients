//
//  MicrophoneHookingCategory.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MicrophoneInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"
#import "MicrophoneInputSupervisor.h"
#import "InputSupervisorsManager.h"


@interface AVCaptureDevice(rsHook_Microphone)

@end

@implementation AVCaptureDevice(rsHook_Microphone)

+(void)load {
    if (NSClassFromString(@"AVCaptureDevice")) {
        [self jr_swizzleClassMethod:@selector(defaultDeviceWithMediaType:) withClassMethod:@selector(rsHook_Microphone_defaultDeviceWithMediaType:) error:nil];
    }
}

+(AVCaptureDevice*)rsHook_Microphone_defaultDeviceWithMediaType:(NSString *)mediaType{
    
    if (mediaType == AVCaptureDeviceTypeBuiltInMicrophone) {
        MicrophoneInputSupervisor *supervisor = [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[MicrophoneInputSupervisor class]];
        
        [supervisor processMicrophoneUsage];
    }
    return [self rsHook_Microphone_defaultDeviceWithMediaType:mediaType];
}

@end
