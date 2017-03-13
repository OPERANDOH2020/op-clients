//
//  AVCaptureDevice+rsHookCamera.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"


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
    }
    
    return [self rsHook_Camera_defaultDeviceWithMediaType:mediaType];
}

@end
