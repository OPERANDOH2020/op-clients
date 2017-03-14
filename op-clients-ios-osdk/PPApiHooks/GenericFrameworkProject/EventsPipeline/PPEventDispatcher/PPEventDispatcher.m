//
//  PPEventDispatcher.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventDispatcher.h"
#import "PPEventDispatcher+Internal.h"

#define SAFECALL(x, ...) if(x){x(__VA_ARGS__);}

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
    NSString *identifier = [NSString stringWithFormat:@"%ld", (unsigned long)self.handlersArray.count];
    IdentifiedHandler *ih = [[IdentifiedHandler alloc] initWithIdentifier:identifier handler:eventHandler];
    
    [self.handlersArray addObject:ih];
    return identifier;
    
}

-(void)removeHandlerWithIdentifier:(NSString *)identifier {
    NSInteger index = [self.handlersArray indexOfObjectPassingTest:^BOOL(IdentifiedHandler * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IdentifiedHandler *ih = obj;
        return [ih.identifier isEqualToString:identifier];
    }];
    
    if (index != NSNotFound) {
        [self.handlersArray removeObjectAtIndex:index];
    }
}

-(void)internalFireEvent:(PPEvent*)event {
    [self fireEvent:event forHandlerAtIndex:0];
}


-(void)fireEvent:(PPEvent *)event forHandlerAtIndex:(NSInteger)index {
    if (index >= self.handlersArray.count || index < 0) {
        return;
    }
    
    __weak PPEventDispatcher *weakSelf = self;
    
    IdentifiedHandler *ih = self.handlersArray[index];
    NextHandlerConfirmation confirmation = nil;
    if (index + 1 < self.handlersArray.count) {
        confirmation = ^{
            [weakSelf fireEvent:event forHandlerAtIndex:index + 1];
        };
    }
    
    SAFECALL(ih.handler, event, confirmation)
}

@end


@implementation PPEventDispatcher(Internal)
-(void)fireEvent:(PPEvent *)event {
    [self internalFireEvent:event];
}
@end
