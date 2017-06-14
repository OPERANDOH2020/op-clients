//
//  PPApiHooksStart.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPApiHooksStart.h"
#import "NSURLSession+PPHOOK.h"
#import "UIDevice+PPHOOK.h"
#import "HookURLProtocol.h"
#import "LAContext+PPHOOK.h"
#import "CMPedometer+PPHOOK.h"
#import "CMMotionManager+PPHOOK.h"
#import "CMAltimeter+PPHOOK.h"
#import "AVCaptureDevice+PPHOOK.h"
#import "UIDevice+PPHOOK.h"
#import <mach-o/dyld.h>
#import <libgen.h>
#import <dlfcn.h>
#import <mach-o/loader.h>

void checkDynamicImage(const struct mach_header* mh, intptr_t vmaddr_slide){
    
    const intptr_t spot = sizeof(struct mach_header_64) + mh->sizeofcmds;
    intptr_t address = spot + vmaddr_slide;
    Dl_info info;
    if(dladdr((const void*)address, &info)){
        printf("Found dynamic library named: %s %s\n ", info.dli_fname, info.dli_sname);
    }
}  

@implementation PPApiHooksStart

+(void)load{
    
    NSArray *classList = @[ [NSURLSession class],
                            [UIDevice class],
                            [HookURLProtocol class],
                            [CMPedometer class],
                            [CMMotionManager class],
                            [CMAltimeter class],
                            [AVCaptureDevice class]];
    
    
    
    for (id class in classList) {
        [self registerHookedClass:class];
    }
    
    char pathbuf[PATH_MAX + 1];
    char real_executable[PATH_MAX + 1];
    char *bundle_id;
    unsigned int  bufsize = sizeof(pathbuf);
    
    _NSGetExecutablePath( pathbuf, &bufsize);
    
    bundle_id = dirname(pathbuf);
    
    strcpy(real_executable, bundle_id);
    strcat(real_executable, "/");
    
    NSLog(@"Application executable path: %s \n %s", pathbuf, real_executable);
    NSLog(@"PPApiHooksCore framework path: %@", [[NSBundle mainBundle] privateFrameworksPath]);
    
    NSLog(@"Now registering the callback function");
    _dyld_register_func_for_add_image(&checkDynamicImage);
}

+(void)registerHookedClass:(Class)class{
    PPEventDispatcher *sharedDispatcher = [PPEventDispatcher sharedInstance];
    CALL_PREFIXED(class, setEventsDispatcher: sharedDispatcher);
}

@end
