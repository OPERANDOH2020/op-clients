//
//  AuthenticationKeyGenerator.h
//  PPApiHooksCore
//
//  Created by Costin Andronache on 6/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef AuthenticationKeyGenerator_h
#define AuthenticationKeyGenerator_h

typedef void(^KeyExecutionBlock)(char*);

extern char* (*keyGenerator)();
extern void (*apiHooksCore_withSafelyManagedKey)(KeyExecutionBlock block);

#endif /* AuthenticationKeyGenerator_h */
