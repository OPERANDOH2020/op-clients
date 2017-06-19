//
//  Security.c
//  PPCloak
//
//  Created by Costin Andronache on 6/15/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//  Note: Later on, we should find a way to build the strings at runtime

#include "Security.h"
#import <iOSNM/iOSNM.h>
#import <PPApiHooksCore/PPApiHooksCore.h>
#import <Foundation/Foundation.h>

static inline void printErrorSwizzling(char *symbol, char *frameworkName, char *innocentFramework){
    
    NSString *message = [NSString stringWithFormat:@"The framework [%s] defines the symbol (%s) which is also defined in [%s]. This usually indicates that there is an attempt to bypass security features implemented in [%s], via method swizzling. If this is not the case, then please redo the linking order of the frameworks such that [%s] is linked before [%s]", frameworkName, symbol, innocentFramework, innocentFramework, innocentFramework, frameworkName];
    
    NSException *excp = [NSException exceptionWithName:@"" reason:message userInfo:nil];
    [excp raise];
    
    
    printf("%s", message.UTF8String);
    abort();
}

void frameworkDidSwizzleClassesInApiHooks(char *symbol, char *frameworkName){
    printErrorSwizzling(symbol, frameworkName, "PPApiHooksCore");
}

void frameworkDidSwizzleOPMonitor(char *symbol, char *frameworkName){
    printErrorSwizzling(symbol, frameworkName, "PPCloak");
}

inline void checkNoSwizzlingForApiHooks(){
    int numOfClasses = 0;
    char **classList = PPApiHooks_createListOfCurrentlyRegisteredClassNames(&numOfClasses);
    ObjcSymbolsDetectModel *model = (ObjcSymbolsDetectModel*)malloc(sizeof(ObjcSymbolsDetectModel));
    
    if (numOfClasses == 0) {
        assert(1 == 0 && "Did not expect that list of current registered classes is zero");
    }
    

    model->frameworkName = "PPApiHooksCore";
    model->objcSymbolsToCheck = classList;
    model->numOfObjcSymbols = numOfClasses;
    model->callback = &frameworkDidSwizzleClassesInApiHooks;
    
    checkObjcSymbolsDefinedBeforeFramework(model);
    
}


inline void checkNoSwizzlingForOPMonitor(){
    char **p = (char**)malloc(sizeof(char*));
    p[0] = (char*)&"OPMonitor";
    ObjcSymbolsDetectModel *model = (ObjcSymbolsDetectModel*)malloc(sizeof(ObjcSymbolsDetectModel));
    model->frameworkName = "PPCloak";
    model->objcSymbolsToCheck = p;
    model->numOfObjcSymbols = 1;
    model->callback = &frameworkDidSwizzleOPMonitor;
    checkObjcSymbolsDefinedBeforeFramework(model);
}

inline void printErrorForMissingFramework(char *missingFramework, char *key){
    NSString *message = [NSString stringWithFormat:@"The key %s is specified in the app's Info.plist but the framework [%s] is not linked.", key, missingFramework];
    
    [NSException raise:@"" format:message, nil];
    
    printf("%s", message.UTF8String);
    abort();
}

inline void checkForOtherFrameworks(){
    
    CFMutableArrayRef frameworksArray = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    CFMutableArrayRef keysArray = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    CFArrayAppendValue(keysArray, CFSTR("NSContactsUsageDescription"));
    CFArrayAppendValue(frameworksArray, CFSTR("PPContactsApiHook"));
    
    CFArrayAppendValue(keysArray, CFSTR("NSLocationUsageDescription"));
    CFArrayAppendValue(frameworksArray, CFSTR("PPLocationApiHooks"));
    
    CFArrayAppendValue(keysArray, CFSTR("NSLocationWhenInUseUsageDescription"));
    CFArrayAppendValue(frameworksArray, CFSTR("PPLocationApiHooks"));

    //... more to insert here
    
    CFBundleRef bundle = CFBundleGetMainBundle();
    CFDictionaryRef dict =  CFBundleGetInfoDictionary(bundle);
    
    const size_t bufferSize = 128;
    char frameworkNameBuffer[bufferSize];
    char keyNameBuffer[bufferSize];
    
    for (int i=0; i<CFArrayGetCount(keysArray); i++) {
        //1. check if key in plist
        //2. check if framework associated with key is loaded
        //3. print error if any 
    }
    
}


