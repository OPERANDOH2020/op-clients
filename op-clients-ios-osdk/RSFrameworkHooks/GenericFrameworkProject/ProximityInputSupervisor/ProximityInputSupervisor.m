//
//  ProximityInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ProximityInputSupervisor.h"
#import "CommonUtils.h"

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "Common.h"



@interface ProximityInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) AccessedInput *proximitySensor;
@end

@implementation ProximityInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    
    self.delegate = delegate;
    self.document = document;
    self.proximitySensor = [CommonUtils extractInputOfType: InputType.Proximity from:document.accessedInputs];
    
}

-(void)processProximitySensorAccess {
    if (self.proximitySensor) {
        return;
    }
    
    [self.delegate newViolationReported:[[OPMonitorViolationReport alloc] initWithDetails:@"The app uses the proxmity sensor even though it is not specified in the self compliance document!" violationType:TypeUnregisteredSensorAccessed]];
}


@end
