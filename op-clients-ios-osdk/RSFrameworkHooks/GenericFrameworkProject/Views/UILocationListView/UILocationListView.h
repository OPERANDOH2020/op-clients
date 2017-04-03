//
//  UILocationListView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CloakNibView.h"

@interface UILocationListViewCallbacks : NSObject
@property (strong, nonatomic) void (^onDeleteAll)();
@property (strong, nonatomic) void (^onNewLocationAdded)(CLLocation* location);
@property (strong, nonatomic) void (^onDeleteLocationAtIndex)(NSInteger index);
@property (strong, nonatomic) void (^onModifyLocationAtIndex)(CLLocation *location, NSInteger index);

@end

@interface UILocationListView : CloakNibView
@property (readonly, nonatomic) NSArray<CLLocation*> *currentLocations;

-(void)setupWithInitialList:(NSArray<CLLocation*>*)initialLocations callbacks:(UILocationListViewCallbacks*)callbacks;

-(void)addNewLocation:(CLLocation*)location;
-(void)removeLocationAt:(NSInteger)index;
-(void)modifyLocationAt:(NSInteger)index to:(CLLocation*)location;
@end
