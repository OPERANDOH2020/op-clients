//
//  LocationInputSwizzlerSettings.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationInputSwizzlerSettings : NSObject

@property (readonly, nonatomic) NSArray<CLLocation*> *locations;
@property (readonly, nonatomic) BOOL enabled;
@property (readonly, nonatomic) NSTimeInterval changeInterval;
@property (readonly, nonatomic) BOOL cycle;

-(void)synchronizeToUserDefaults;

+(LocationInputSwizzlerSettings*)createWithLocations:(NSArray<CLLocation*>*)locations enabled:(BOOL)enabled cycle:(BOOL)cycle changeInterval:(NSTimeInterval)changeInterval;

+(LocationInputSwizzlerSettings*)createFromUserDefaults;
@end
