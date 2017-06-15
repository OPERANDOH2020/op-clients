
//
//  SymbolInfo.c
//  iOSNM
//
//  Created by Costin Andronache on 6/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#include "SymbolInfo.h"
#include <stdlib.h>
#include <string.h>

void allocAndCopy(char **dest, char *src) {
    if (src) {
        size_t length = strlen(src);
        *dest = malloc(length * sizeof(char) + 1);
        strncpy(*dest, src, length + 1);
    }
}

SymbolInfoArray* createEmptySymbolArray(){
    SymbolInfoArray *p = malloc(sizeof(SymbolInfoArray));
    
    p->bufferSize = 256;
    p->currentSymbols = malloc(p->bufferSize * sizeof(NMSymbolInfo*));
    p->numberOfSymbols = 0;
    return p;
}

NMSymbolInfo* createEmptySymbolInfo() {
    NMSymbolInfo *p = malloc(sizeof(NMSymbolInfo));
    p->libraryNameIfAny = NULL;
    p->sectionName = NULL;
    p->segmentName = NULL;
    p->symbolName = NULL;
    
    p->referenceType = RefType_Unknown;
    
    return p;
}

void addSymbolInfoPointer(NMSymbolInfo *info, SymbolInfoArray *array) {
    
    if (array->numberOfSymbols == array->bufferSize) {
        array->bufferSize *= 2;
        array->currentSymbols = realloc(array->currentSymbols, array->bufferSize * sizeof(NMSymbolInfo*));
    }
    
    array->currentSymbols[array->numberOfSymbols] = info;
    array->numberOfSymbols += 1;
}

void releaseSymbolInfo(NMSymbolInfo *info){
    if (!info) {
        return;
    }
    
    if (info->libraryNameIfAny) {
        free(info->libraryNameIfAny);
    }
    
    if (info->sectionName) {
        free(info->sectionName);
    }
    
    if (info->segmentName) {
        free(info->segmentName);
    }
    
    if (info->symbolName) {
        free(info->symbolName);
    }
    
    free(info);
}




void releaseSymbolInfoArray(SymbolInfoArray *context){
    if (!context) {
        return;
    }
    if (context->currentSymbols) {
        for (int i=0; i<context->numberOfSymbols; i++) {
            releaseSymbolInfo(context->currentSymbols[i]);
        }
        
        free(context->currentSymbols);
    }
    
    free(context);
}

NMSymbolInfo* deepCopySymbolInfo(NMSymbolInfo *unownedInfo){
    NMSymbolInfo *info = createEmptySymbolInfo();
    allocAndCopy(&info->sectionName, unownedInfo->sectionName);
    allocAndCopy(&info->segmentName, unownedInfo->segmentName);
    allocAndCopy(&info->symbolName, unownedInfo->symbolName);
    allocAndCopy(&info->libraryNameIfAny, unownedInfo->libraryNameIfAny);
    info->referenceType = unownedInfo->referenceType;

    return info;
}

void printSymbolInfo(NMSymbolInfo *info) {
    printf("\n (%s, %s) %s", info->segmentName, info->sectionName, info->symbolName);
    if (info->libraryNameIfAny) {
        printf(" from %s", info->libraryNameIfAny);
    }
}
