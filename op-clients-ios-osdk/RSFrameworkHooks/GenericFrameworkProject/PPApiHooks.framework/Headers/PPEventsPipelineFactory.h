//
//  PPEventsPipelineFactory.h
//  PPApiHooks
//
//  Created by Costin Andronache on 3/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEventDispatcher.h"

@interface PPEventsPipelineFactory : NSObject
+(PPEventDispatcher*)eventsDispatcher;
@end
