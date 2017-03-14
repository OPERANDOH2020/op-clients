//
//  PPEvent.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface PPEvent: NSObject
@property (readonly, nonatomic) PPEventType eventType;
@property (strong, nonatomic, nullable) NSMutableDictionary *eventData;

-(instancetype _Nonnull)initWithEventType:(PPEventType)eventType eventData:(NSMutableDictionary* _Nullable)eventData;

@end
