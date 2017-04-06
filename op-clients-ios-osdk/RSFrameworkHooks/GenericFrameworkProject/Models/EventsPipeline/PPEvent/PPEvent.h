//
//  PPEvent.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PPEventType) {
    EventLocationManagerRequestAlwaysAuthorization,
    EventLocationManagerRequestWhenInUseAuthorization
};



@interface PPEvent: NSObject

@property (assign, nonatomic) PPEventType eventType;
@property (strong, nonatomic) NSDictionary *eventData;

@end
