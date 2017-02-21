//
//  UIWindow+RSHookHandle.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIWindow+RSHookHandle.h"
#import "OPMonitor.h"
#import "JRSwizzle.h"

@implementation UIWindow(rsHookHandle)

static UIButton *handle = nil;


+(void)load {
    [self jr_swizzleMethod:@selector(addSubview:) withMethod:@selector(rsHook_addSubview:) error:nil];
}


-(void)rsHook_addSubview:(UIView*)view {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[OPMonitor sharedInstance] getHandle];
        [handle addTarget:self action:@selector(rsHookdragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    });
    
    [self rsHook_addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.subviews containsObject:handle]) {
            [self bringSubviewToFront:handle];
        } else {
            [self rsHook_addSubview:handle];
        }
    });
    
    
}

- (void)rsHookdragMoving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

- (void)rsHookdragEnded: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

@end
