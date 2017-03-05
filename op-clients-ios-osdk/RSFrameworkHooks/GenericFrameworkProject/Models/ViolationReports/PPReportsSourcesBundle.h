//
//  PPReportsSourcesBundle.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

@interface PPReportsSourcesBundle : NSObject
@property (strong, nonatomic) id<PPUnlistedHostReportsSource> unlistedHostReportsSource;
@property (strong, nonatomic) id<PPUnlistedInputReportsSource> unlistedInputReportsSource;
@property (strong, nonatomic) id<PPPrivacyLevelReportsSource> privacyViolationReportsSource;
@end
