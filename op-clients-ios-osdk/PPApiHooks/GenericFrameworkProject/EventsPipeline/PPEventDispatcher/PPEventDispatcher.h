//
//  PPEventDispatcher.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"


typedef void(^NextHandler)();
typedef void(^EventHandler)(PPEvent* _Nonnull event, NextHandler _Nullable nextHandlerIfAny);


@interface PPEventDispatcher : NSObject
+(PPEventDispatcher* _Nonnull) sharedInstance;

-(NSString* _Nonnull)insertNewHandlerAtTop:(EventHandler _Nonnull)eventHandler;
-(void)removeHandlerWithIdentifier:(NSString* _Nonnull)identifier;



@end
