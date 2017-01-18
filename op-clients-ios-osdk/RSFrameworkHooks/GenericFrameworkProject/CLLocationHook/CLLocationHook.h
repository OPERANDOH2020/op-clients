//
//  CLLocationHook.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JRSwizzle.h"

typedef void (^LocationCallbackWithInfo)(NSDictionary*);


@interface CLLocationHook : NSObject

+(void)hookWithCallback:(LocationCallbackWithInfo)callback;

@end
