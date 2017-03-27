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
-(void)prepareWithCompletion:(void(^)(NSError * _Nullable errorIfAny))completion;
-(PPActionForWebContent* _Nonnull)actionForURL:(NSString* _Nonnull)url;

@end
