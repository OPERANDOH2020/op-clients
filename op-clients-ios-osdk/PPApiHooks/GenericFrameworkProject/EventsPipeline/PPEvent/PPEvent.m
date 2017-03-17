//
//  PPEvent.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEvent.h"
#import "Common.h"

@interface PPEvent()
@property (readwrite, assign, nonatomic) PPEventType eventType;
@property (readwrite, strong, nonatomic, nullable) NSMutableDictionary *eventData;
@property (strong, nonatomic) PPVoidBlock whenNoHandlerAvailable;

@end

@implementation PPEvent

-(instancetype)initWithEventType:(PPEventType)eventType eventData:(NSMutableDictionary *)eventData whenNoHandlerAvailable:(PPVoidBlock _Nullable)whenNoHandlerAvailable {
    if (self = [super init]) {
        self.eventData = eventData;
        self.eventType = eventType;
        self.whenNoHandlerAvailable = whenNoHandlerAvailable;
    }
    
    return self;
}


-(void)consumeWhenNoHandlerAvailable {
    SAFECALL(self.whenNoHandlerAvailable)
}

@end
