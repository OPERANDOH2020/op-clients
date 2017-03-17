//
//  PPEventDispatcher+Internal.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEventDispatcher.h"

@interface PPEventDispatcher(Internal)
-(void)fireEvent:(PPEvent* _Nonnull)event;


-(void)fireSafeEventForType:(PPEventType)type executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey;

@end
