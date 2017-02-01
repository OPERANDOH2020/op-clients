//
//  MicrophoneInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MicrophoneInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"

typedef void(^MicrophoneInputCallback)();
MicrophoneInputCallback _globalMicrophoneCallback;


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
        SAFECALL(_globalMicrophoneCallback)
    }
    return [self rsHook_Microphone_defaultDeviceWithMediaType:mediaType];
}

@end

@interface MicrophoneInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedSensor *micSensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation MicrophoneInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.document = document;
    self.delegate = delegate;
    self.micSensor = [CommonUtils extractSensorOfType:SensorType.Microphone from:document.accessedSensors];
    
    __weak typeof(self) weakSelf = self;
    _globalMicrophoneCallback = ^void(){
        [weakSelf processMicrophoneUsage];
    };
}


-(void)processMicrophoneUsage {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}

-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.micSensor) {
        return nil;
    }
    
    return [[OPMonitorViolationReport alloc] initWithDetails:@"The app accesses the microphone even though it is not specified in the self-compliance document!" violationType:TypeUnregisteredSensorAccessed];
}

@end
