//
//  PPWebContentBlockerEngine.h
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPActionForWebContent.h"

@interface PPWebContentBlockerEngine : NSObject
-(void)prepareWithCompletion:(void(^ _Nonnull)(NSError * _Nullable errorIfAny))completion;
-(WebContentActionType)actionForRequest:(NSURLRequest* _Nonnull)request;

@end
