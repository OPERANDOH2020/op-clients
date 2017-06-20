//
//  Strings.c
//  PPCloak
//
//  Created by Costin Andronache on 6/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//  Note: Must create the actual char* arrays via obfuscation,
//  not by plainly exposing them in the cStrings section in the binary.

#include "Strings.h"



static CFStringRef generateNSLocationAlwaysUsageDescription(){
    return CFSTR("NSLocationAlwaysUsageDescription");
}

static CFStringRef generatePPContactsApiHook(){
    return CFSTR("PPContactsApiHook");
}
