//
//  PPActionForWebContent.h
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WebContentActionType) {
    TypeAllowContent,
    TypeBlockContent,
    TypeAllowAndExecuteScriptAtLoad,
};

#define kWebContentCleaningScript @"kWebContentCleaningScript"

@interface PPActionForWebContent : NSObject
@property (readonly, nonatomic) WebContentActionType actionType;
@property (readonly, nonatomic, nullable) NSString *scriptToExecuteIfAny;

-(instancetype _Nonnull)initWithActionType:(WebContentActionType)actionType scriptIfAny:(NSString* _Nullable)script;

@end
