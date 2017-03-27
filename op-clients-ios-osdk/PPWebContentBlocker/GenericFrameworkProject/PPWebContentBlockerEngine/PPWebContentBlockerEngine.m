//
//  PPWebContentBlockerEngine.m
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPWebContentBlockerEngine.h"

@implementation PPWebContentBlockerEngine


-(void)prepareWithCompletion:(void (^)(NSError * _Nullable))completion {
    completion(nil);
}

-(PPActionForWebContent *)actionForURL:(NSString *)url {
    
    return [[PPActionForWebContent alloc] initWithActionType:TypeAllowContent scriptIfAny:nil];
}

@end
