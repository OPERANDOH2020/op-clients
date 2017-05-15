//
//  PPApiHooksStart.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPApiHooksStart.h"
#import "PPEventDispatcher+Internal.h"
#import "NSURLSession+PPHOOK.h"
#import "UIDevice+PPHOOK.h"
#import "HookURLProtocol.h"
#import "LAContext+PPHOOK.h"
#import "CNContactStore+PPHOOK.h"
#import "CMPedometer+PPHOOK.h"
#import "CMMotionManager+PPHOOK.h"
#import "CMAltimeter+PPHOOK.h"
#import "CLLocationManager+PPHOOK.h"
#import "AVCaptureDevice+PPHOOK.h"
#import "UIDevice+PPHOOK.h"

@implementation PPApiHooksStart

+(void)load{
    
    NSArray *classList = @[ [NSURLSession class],
                            [UIDevice class],
                            [HookURLProtocol class],
//                            [LAContext class],
//                            [CNContactStore class],
                            [CMPedometer class],
                            [CMMotionManager class],
                            [CMAltimeter class],
//                            [CLLocationManager class],
                            [AVCaptureDevice class]];
    
    
    PPEventDispatcher *sharedDispatcher = [PPEventDispatcher sharedInstance];
    for (id class in classList) {
        CALL_PREFIXED(class, setEventsDispatcher: sharedDispatcher);
    }
    
}

@end
