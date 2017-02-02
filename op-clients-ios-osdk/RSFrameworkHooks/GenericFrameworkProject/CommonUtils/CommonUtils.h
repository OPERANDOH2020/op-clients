//
//  CommonUtils.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>

@interface CommonUtils : NSObject

+(AccessedInput *)extractInputOfType:(NSString *)type from:(NSArray<AccessedInput *> *)sensors;
@end
