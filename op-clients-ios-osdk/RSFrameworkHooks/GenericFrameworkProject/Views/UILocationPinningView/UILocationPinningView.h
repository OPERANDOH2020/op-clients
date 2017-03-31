//
//  UILocationPinningView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface UILocationPinningView : UIView
@property (readonly, nonatomic) NSArray<CLLocation*> *currentLocationsOnMap;

-(void)setupWithLocations:(NSArray<CLLocation*>*)locations;
-(void)clearAll;
@end
