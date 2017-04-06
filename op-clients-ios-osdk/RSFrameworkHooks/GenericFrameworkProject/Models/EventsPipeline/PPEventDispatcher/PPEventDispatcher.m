//
//  PPEventDispatcher.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventDispatcher.h"

@interface PPEventDispatcher()
@end

@implementation PPEventDispatcher

+(PPEventDispatcher *)sharedInstance {
    static PPEventDispatcher *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPEventDispatcher alloc] init];
    });
    
    return sharedInstance;
}

@end
