//
//  AuthenticationKeyGenerator.c
//  PPApiHooksCore
//
//  Created by Costin Andronache on 6/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//




#include "AuthenticationKeyGenerator.h"
#include <stdlib.h>
#include <string.h>

char* fwZtJHFJrz() {
    int count = 255;
    char *result = malloc(count * sizeof(char) + 1);
    for (int i = 0; i<count; i++) {
        result[i] = i << (i % sizeof(char));
        result[i] = result[i] ^ i;
    }
    
    result[count] = '\0';
    return result;
}

char* QkLpZHRCAK() {
    
    char *from = fwZtJHFJrz();
    unsigned long length = strlen(from);
    for (int i = 0; i<length; i++) {
        char *iAddr = (char*)&i;
        from[i] = from[i] & iAddr[ i % sizeof(int)];
    }
    
    return from;
}

char* kByXlUHpzQ() {
    int len = 12;
    char *alphabet = malloc(len * sizeof(char) + 1);
    for (int i = 0; i<len; i++) {
        alphabet[i] = 'a' + i;
    }
    
    return alphabet;
}

char* HTfTXzgjBE() {
    char *a = fwZtJHFJrz();
    char *b = QkLpZHRCAK();
    char *c = kByXlUHpzQ();
    
    unsigned long lenA = strlen(a);
    unsigned long lenB = strlen(b);
    unsigned long lenC = strlen(c);
    unsigned long totalLength = lenA + lenB + lenC;
    
    char *finish = malloc(totalLength * sizeof(char) + 1);
    int i = 0;
    for (int ait = 0; ait < lenA; ait++){
        finish[i++] = a[ait];
    }
    for (int bit = 0; bit < lenB; bit++) {
        finish[i++] = b[bit];
    }
    for (int cit = 0; cit < lenC; cit++) {
        finish[i++] = c[cit];
    }
    
    free(a);
    free(b);
    free(c);
    
    finish[totalLength] = '\0';
    return finish;
}

char* (*keyGenerator)() = &HTfTXzgjBE;


void EeKtDBWkTK(KeyExecutionBlock block){
    char *key = keyGenerator();
    block(key);
    free(key);
}

void (*apiHooksCore_withSafelyManagedKey)(KeyExecutionBlock block) = &EeKtDBWkTK;
