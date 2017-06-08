//
//  PPEventDispatcher.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"
#import "IdentifiedHandler.h"

@interface PPEventDispatcher: NSObject

+(PPEventDispatcher* _Nonnull) sharedInstanceWithAuthentication:(char*_Nonnull)unownedAuthenticationString;

-(NSString* _Nonnull)insertAtTopNewHandler:(EventHandler _Nonnull)eventHandler authentication:(char* _Nonnull)unownedAuthenticationString;

-(void)removeHandlerWithIdentifier:(NSString* _Nonnull)identifier authentication:(char* _Nonnull)unownedAuthenticationString;

-(void)fireEvent:(PPEvent* _Nonnull)event authentication:(char* _Nonnull)unownedAuthenticationString;

-(void)fireEventWithMaxOneTimeExecution:(PPEventIdentifier)identifier executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey authentication:(char* _Nonnull)unownedAuthenticationString;

-(id _Nullable)resultForEventValue:(id _Nonnull)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key authentication:(char* _Nonnull)unownedAuthenticationString;

-(BOOL)resultForBoolEventValue:(BOOL)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key authentication:(char* _Nonnull)unownedAuthenticationString;

@end
