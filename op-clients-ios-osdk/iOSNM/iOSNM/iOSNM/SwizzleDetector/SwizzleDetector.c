//
//  SwizzleDetector.c
//  iOSNM
//
//  Created by Costin Andronache on 6/14/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#include "SwizzleDetector.h"
#import "nm.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <dlfcn.h>
#import <string.h>
#import <stdio.h>
#import <stdlib.h>

void processSymbols(SymbolsContext *context, char *frameworkName);
char* extractLastPathItem(const char *path);


void dylibListener(const struct mach_header* mh, intptr_t vmaddr_slide){
    const intptr_t spot = sizeof(struct mach_header_64) + mh->sizeofcmds;
    intptr_t address = spot + vmaddr_slide;
    Dl_info info;
    if(dladdr((const void*)address, &info)){
        if (strstr(info.dli_fname, "libswift")) {
            // ignore swift libraries
            return;
        }
        char *frameworkName = extractLastPathItem(info.dli_fname);
        SymbolsContext *context = retrieveSymbolsFromFile(info.dli_fname);
        processSymbols(context, frameworkName);
    }

}

__attribute__((constructor))
void registerListener() {
    _dyld_register_func_for_add_image(&dylibListener);
}

void processSymbols(SymbolsContext *context, char *frameworkName){
    
    printf("\nFor framework: %s\n", frameworkName);
    for (int i=0; i<context->numberOfSymbols; i++) {
        printSymbolInfo(context->currentSymbols[i]);
        
    }
    
    releaseSymbolsContext(context);
}


char *extractLastPathItem(const char *path){
    if (!path) {
        return NULL;
    }
    
    char *p = (char *)(path + strlen(path));
    while (*(p-1) != '/' && p != path) {
        p -= 1;
    }
    
    size_t length = p - path + 1;
    char *result = (char*)malloc(length * sizeof(char) + 1);
    strcpy(result, p);
    return result;
    
};

