//
//  PPEventDispatcher.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventDispatcher.h"
#import "PPEventDispatcher+Internal.h"

@interface IdentifiedHandler : NSObject
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) EventHandler handler;
@end

@implementation IdentifiedHandler
-(instancetype)initWithIdentifier:(NSString*)identifier handler:(EventHandler)handler {
    if (self = [super init]) {
        self.identifier = identifier;
        self.handler = handler;
    }
    
    return self;
}
@end



@interface PPEventDispatcher()
@property (strong, nonatomic) NSMutableArray<IdentifiedHandler*> *handlersArray;
@end

@implementation PPEventDispatcher

-(instancetype)init {
    if (self = [super init]) {
        self.handlersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(PPEventDispatcher *)sharedInstance {
    static PPEventDispatcher *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPEventDispatcher alloc] init];
    });
    
    return sharedInstance;
}

-(NSString *)insertNewHandlerAtTop:(EventHandler)eventHandler {
    NSString *identifier = [NSString stringWithFormat:@"%ld", self.handlersArray.count];
    IdentifiedHandler *ih = [[IdentifiedHandler alloc] initWithIdentifier:identifier handler:eventHandler];
    
    [self.handlersArray addObject:ih];
    return identifier;
    
}

-(void)ppApiHooks_internalFireEvent:(PPEvent*)event {
    
    
    
}

@end


@implementation PPEventDispatcher(Internal)
-(void)fireEvent:(PPEvent *)event {
    [self ppApiHooks_internalFireEvent:event];
}
@end
