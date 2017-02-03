//
//  InputSupervisorsManager.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "InputSupervisorsManager.h"
#import "SupervisorProtocols.h"

@interface InputSupervisorsManager()
@property (strong, nonatomic) NSArray<id<InputSourceSupervisor>> *inputSupervisors;
@end


static InputSupervisorsManager *_sharedInstance;

@implementation InputSupervisorsManager


-(id)initWithSupervisors:(NSArray<id<InputSourceSupervisor>>*)supervisors {
    if (self = [super init]) {
        self.inputSupervisors = supervisors;
    }
    
    return self;
}

+(InputSupervisorsManager *)sharedInstance {
    return _sharedInstance;
}


+(void)buildSharedInstanceWithSupervisors:(NSArray<id<InputSourceSupervisor>> *)supervisors{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[InputSupervisorsManager alloc] initWithSupervisors:supervisors];
    });
}

-(id)inputSupervisorOfType:(Class)type {
    
    for (id is in self.inputSupervisors) {
        if ([is isKindOfClass:type]) {
            return is;
        }
    }
    
    return nil;
}



@end
