//
//  MicrophoneHookingCategory.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"
#import "NSObject+AutoSwizzle.h"
#import "PPEventDispatcher+Internal.h"

@interface AVCaptureDevice(rsHook_Microphone)

@end

@implementation AVCaptureDevice(rsHook_Microphone)

+(void)load {
    if (NSClassFromString(@"AVCaptureDevice")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}


@end
