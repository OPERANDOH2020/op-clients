//
//  UILocationPinningView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface UILocationPinningViewCallbacks: NSObject
@property (strong, nonatomic) void (^onNewLocationAdded)(CLLocation *location);
@property (strong, nonatomic) void (^onDeleteLocationAtIndex)(NSInteger index);
@property (strong, nonatomic) void (^onModifyLocationAtIndex)(CLLocation *location, NSInteger index);
@end

@interface UILocationPinningView : UIView
@property (readonly, nonatomic) NSArray<CLLocation*> *currentLocationsOnMap;

-(void)setupWithLocations:(NSArray<CLLocation*>*)locations callbacks:(UILocationPinningViewCallbacks*)callbacks;
-(void)addNewLocation:(CLLocation*)location;
-(void)modifyLocationAt:(NSInteger)index toLatitude:(double)latitude andLongitude:(double)longitude;
-(void)deleteLocationAt:(NSInteger)index;
-(void)clearAll;
@end
