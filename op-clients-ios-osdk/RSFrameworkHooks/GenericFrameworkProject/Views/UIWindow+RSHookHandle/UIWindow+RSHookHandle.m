//
//  UIWindow+RSHookHandle.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIWindow+RSHookHandle.h"
#import "OPMonitor.h"
#import "SPUserResizableView.h"
#import "JRSwizzle.h"

@implementation UIWindow(rsHookHandle)

+(void)load {
    [self jr_swizzleMethod:@selector(addSubview:) withMethod:@selector(rsHook_addSubview:) error:nil];
}


-(void)rsHook_addSubview:(UIView*)view {
    
    static UIButton *handle = nil;
    static SPUserResizableView *resizbleView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[OPMonitor sharedInstance] getHandle];
        resizbleView = [[SPUserResizableView alloc] initWithFrame:handle.bounds];
        resizbleView.frame = handle.frame;
        handle.frame = resizbleView.bounds;
        resizbleView.contentView = handle;
        resizbleView.userInteractionEnabled = YES;
        resizbleView.keepEditingHandlesHidden = YES;
        
        
        
    });
    
    [self rsHook_addSubview:view];
    
    if ([self.subviews containsObject:resizbleView]) {
        [self bringSubviewToFront:resizbleView];
    } else {
        [self rsHook_addSubview:resizbleView];
    }
    
}

@end
