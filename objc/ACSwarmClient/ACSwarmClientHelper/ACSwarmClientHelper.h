//
//  ACSwarmClientHelper.h
//  USMED
//
//  Created by Cătălin Pomîrleanu on 12/1/16.
//  Copyright (c) 2015 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACSwarmClientHelper : NSObject

+ (NSDictionary *)dictionaryForServerRequestType:(NSInteger)reqType sessionId:(NSString *)sessionId swarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor arguments:(NSArray *)args;

+ (NSDictionary *)addSession:(NSString *)session parameters:(NSDictionary *)parameters;

@end
