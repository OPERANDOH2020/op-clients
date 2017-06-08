//
//  PPEventDispatcher.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventDispatcher.h"
#import "Common.h"
#import "PPEvent+FrameworkPrivate.h"
#import "AuthenticationKeyGenerator.h"

#define authenticate(x) \
char *myKey = keyGenerator();\
if(strcmp(myKey, x) != 0){ \
ScKHlqaeqE();\
} else {\
  free(myKey);\
}




void ScKHlqaeqE() {
    
    int a = 10;
    int b = (int)&a;
    int *p = 0x0;
    
    assert((int)p == b || a == b);
}

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

+(PPEventDispatcher *)sharedInstanceWithAuthentication:(char *)unownedAuthenticationString {
    
    authenticate(unownedAuthenticationString)
    
    static PPEventDispatcher *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPEventDispatcher alloc] init];
    });
    
    return sharedInstance;
}

-(NSString*)insertAtTopNewHandler:(EventHandler _Nonnull)eventHandler authentication:(char * _Nonnull)unownedAuthenticationString {
    authenticate(unownedAuthenticationString)
    
    NSString *identifier = [NSString stringWithFormat:@"%ld", (unsigned long)self.handlersArray.count];
    IdentifiedHandler *ih = [[IdentifiedHandler alloc] initWithIdentifier:identifier handler:eventHandler];
    [self.handlersArray addObject:ih];
    return identifier;
}

-(void)removeHandlerWithIdentifier:(NSString *)identifier authentication:(char * _Nonnull)unownedAuthenticationString {
    
    authenticate(unownedAuthenticationString)
    
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
        [event consumeWhenNoHandlerAvailable];
        return;
    }
    
    __weak PPEventDispatcher *weakSelf = self;
    
    IdentifiedHandler *ih = self.handlersArray[index];
    NextHandlerConfirmation confirmation = nil;
    if (index + 1 < self.handlersArray.count) {
        confirmation = ^{
            [weakSelf fireEvent:event forHandlerAtIndex:index + 1];
        };
    } else {
        confirmation = ^ {
            [event consumeWhenNoHandlerAvailable];
        };
    }
    
    SAFECALL(ih.handler, event, confirmation)
}


-(void)fireEvent:(PPEvent *)event authentication:(char * _Nonnull)unownedAuthenticationString {
    
    authenticate(unownedAuthenticationString)
    [self internalFireEvent:event];
}

-(void)fireEventWithMaxOneTimeExecution:(PPEventIdentifier)type executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey authentication:(char * _Nonnull)unownedAuthenticationString {
    
    authenticate(unownedAuthenticationString)
    
    __block BOOL didExecute = NO;
    PPVoidBlock confirmation =  ^{
        if (didExecute) {
            return;
        }
        didExecute = YES;
        SAFECALL(executionBlock)
    };
    
    NSMutableDictionary *dict = [@{
                                   executionBlockKey: confirmation
                                   } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:type eventData:dict whenNoHandlerAvailable:executionBlock];
    
    char *authenticationKey = keyGenerator();
    [self fireEvent:event authentication:authenticationKey];
    free(authenticationKey);
}

-(id)resultForEventValue:(id)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString *)key authentication:(char * _Nonnull)unownedAuthenticationString{
    
    authenticate(unownedAuthenticationString)
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    SAFEADD(dict, key, value)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:identifier eventData:dict whenNoHandlerAvailable:nil];
    
    char *authenticationKey = keyGenerator();
    [self fireEvent:event authentication:authenticationKey];
    free(authenticationKey);
    
    return [event.eventData objectForKey:key] ;
}

-(BOOL)resultForBoolEventValue:(BOOL)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString *)key authentication:(char * _Nonnull)unownedAuthenticationString{
    
    authenticate(unownedAuthenticationString)
    return [[self resultForEventValue:@(value) ofIdentifier:identifier atKey:key authentication:unownedAuthenticationString] boolValue];
}

@end
