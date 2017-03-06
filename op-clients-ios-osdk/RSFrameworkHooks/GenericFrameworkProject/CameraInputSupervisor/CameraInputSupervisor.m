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
    
}

-(void)processCameraAccess {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(void)processPhotoLibraryAccess {
    [self processCameraAccess];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.cameraSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Camera dateReported:[NSDate date]];
}

@end
