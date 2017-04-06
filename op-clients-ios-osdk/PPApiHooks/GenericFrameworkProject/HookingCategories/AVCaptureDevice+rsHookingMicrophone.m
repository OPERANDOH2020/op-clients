//
//  MicrophoneHookingCategory.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"


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
    }
    
    return [self rsHook_Microphone_defaultDeviceWithMediaType:mediaType];
}

@end
