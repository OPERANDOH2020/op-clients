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


@interface MicrophoneInputSupervisor()

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *micSensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation MicrophoneInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    
    self.document = document;
    self.delegate = delegate;
    self.micSensor = [CommonUtils extractInputOfType:InputType.Microphone from:document.accessedInputs];
    
}


-(void)processMicrophoneUsage {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.micSensor) {
        return nil;
    }
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Microphone dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
