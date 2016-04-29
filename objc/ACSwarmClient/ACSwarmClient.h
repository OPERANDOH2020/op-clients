//
//  ACSwarmClient.h
//  USMED
//
//  Created by Cătălin Pomîrleanu on 12/1/16.
//  Copyright (c) 2015 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACSwarmClient : NSObject

- (id)init;
- (void)createSocket;
- (void)emitRequestWithSwarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor arguments:(NSArray *)args serverRequestType:(NSInteger)reqType;
- (void)getLoginApprovalForUsername:(NSString *)username andPassword:(NSString *)password;

@end
