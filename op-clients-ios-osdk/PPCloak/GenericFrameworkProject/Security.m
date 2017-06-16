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



void printErrorSwizzling(char *symbol, char *frameworkName, char *innocentFramework){
    printf("The framework [%s] defines the symbol (%s) which is also defined in [%s]. This usually indicates that there is an attempt to bypass security features implemented in [%s], via method swizzling. If this is not the case, then please redo the linking order of the frameworks such that [%s] is linked before [%s]", frameworkName, symbol, innocentFramework, innocentFramework, innocentFramework, frameworkName);
    
    abort();
}

void frameworkDidSwizzleClassesInApiHooks(char *symbol, char *frameworkName){
    printErrorSwizzling(symbol, frameworkName, "PPApiHooksCore");
}

void frameworkDidSwizzleOPMonitor(char *symbol, char *frameworkName){
    printErrorSwizzling(symbol, frameworkName, "PPCloak");
}

void checkNoSwizzlingForApiHooks(){
    int numOfClasses = 0;
    char **classList = createListOfCurrentlyRegisteredClassNames(&numOfClasses);
    ObjcSymbolsDetectModel *model = malloc(sizeof(ObjcSymbolsDetectModel));
    
    if (numOfClasses == 0) {
        assert(1 == 0 && "Did not expect that list of current registered classes is zero");
    }
    

    model->frameworkName = "PPApiHooksCore";
    model->objcSymbolsToCheck = classList;
    model->numOfObjcSymbols = numOfClasses;
    model->callback = &frameworkDidSwizzleClassesInApiHooks;
    
    checkObjcSymbolsDefinedBeforeFramework(model);
    
}


void checkNoSwizzlingForOPMonitor(){
    char **p = malloc(sizeof(char**));
    p[0] = (char*)&"OPMonitor";
    ObjcSymbolsDetectModel *model = malloc(sizeof(ObjcSymbolsDetectModel));
    model->frameworkName = "PPCloak";
    model->objcSymbolsToCheck = p;
    model->numOfObjcSymbols = 1;
    model->callback = &frameworkDidSwizzleOPMonitor;
    checkObjcSymbolsDefinedBeforeFramework(model);
}
