//
//  LocationInputSwizzler.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInputSwizzlerSettings.h"




@interface LocationInputSwizzler : NSObject

@property (readonly, nonatomic) LocationInputSwizzlerSettings *currentSettings;
-(void)applySettings:(LocationInputSwizzlerSettings*)settings;

+(LocationInputSwizzler*)sharedInstance;

@end
