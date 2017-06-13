//
//  nm.h
//  PPApiHooksCore
//
//  Created by Costin Andronache on 6/12/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef nm_h
#define nm_h

typedef enum {
    RefType_Unknown,
    RefType_Dynamic,
    RefType_Weak_Private_External,
    RefType_Private_External,
    RefType_Weak_External_Auto_Hidden,
    RefType_Weak_External,
    RefType_External,
    RefType_Non_External
} NMSymbolReferenceType;

typedef struct  {
    char* segmentName;
    char* sectionName;
    char* libraryNameIfAny;
    char* symbolName;
    NMSymbolReferenceType referenceType;
} NMSymbolInfo;

typedef struct {
    NMSymbolInfo **currentSymbols;
    int numberOfSymbols;
    int bufferSize;
} SymbolsContext;


SymbolsContext* retrieveSymbolsFromFile(const char* filePath);
void printSymbolInfo(NMSymbolInfo *info);
void releaseSymbolsContext(SymbolsContext *context);

#endif /* nm_h */
