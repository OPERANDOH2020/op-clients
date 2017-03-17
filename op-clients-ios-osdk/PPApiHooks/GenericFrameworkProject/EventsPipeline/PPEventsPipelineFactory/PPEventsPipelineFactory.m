//
//  PPEventsPipelineFactory.m
//  PPApiHooks
//
//  Created by Costin Andronache on 3/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventsPipelineFactory.h"

@implementation PPEventsPipelineFactory
+(PPEventDispatcher *)eventsDispatcher {
    return [PPEventDispatcher sharedInstance];
}
@end
