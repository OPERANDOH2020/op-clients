//
//  PPEventDispatcher.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"

@interface PPEventDispatcher : NSObject
+(PPEventDispatcher* _Nonnull) sharedInstance;


@end