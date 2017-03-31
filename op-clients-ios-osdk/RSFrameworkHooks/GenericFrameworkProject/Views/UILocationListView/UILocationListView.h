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

@property (strong, nonatomic) void (^onModifyLocationAtIndex)(CLLocation *location, NSInteger index);

@end

@interface UILocationListView : CloakNibView

-(void)setupWithInitialList:(NSArray<CLLocation*>*)initialLocations callbacks:(UILocationListViewCallbacks*)callbacks;

@end
