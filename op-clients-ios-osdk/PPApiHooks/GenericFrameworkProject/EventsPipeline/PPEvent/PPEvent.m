//
//  PPEvent.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEvent.h"

@interface PPEvent()
@property (readwrite, assign, nonatomic) PPEventType eventType;
@end

@implementation PPEvent

-(instancetype)initWithEventType:(PPEventType)eventType eventData:(NSMutableDictionary *)eventData {
    if (self = [super init]) {
        self.eventData = eventData;
        self.eventType = eventType;
    }
    
    return self;
}

@end
