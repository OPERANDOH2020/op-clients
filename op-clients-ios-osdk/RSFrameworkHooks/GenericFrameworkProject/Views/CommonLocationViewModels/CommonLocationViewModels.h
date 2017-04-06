//
//  CommonLocationViewModels.h
//  PPCloak
//
//  Created by Costin Andronache on 4/4/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationInputSwizzlerSettings.h"

@interface CommonLocationViewCallbacks : NSObject
@property (strong, nonatomic) void (^ _Nullable onDeleteAll)();
@property (strong, nonatomic) void (^ _Nullable onNewLocationAdded)(CLLocation* _Nonnull location);
@property (strong, nonatomic) void (^ _Nullable onDeleteLocationAtIndex)(NSInteger index);
@property (strong, nonatomic) void (^ _Nullable onModifyLocationAtIndex)(CLLocation * _Nonnull location, NSInteger index);
@end

@interface CommonLocationViewModel : NSObject
@property (readonly, nonatomic, nonnull) NSArray<CLLocation*> *initialLocations;
@property (readonly, nonatomic) BOOL editable;
-(instancetype _Nullable)initWithLocations:(NSArray<CLLocation*>* _Nonnull)locations editable:(BOOL)editable;
@end

typedef void(^CurrentActiveLocationIndexChangedCallback)(NSInteger newIndex);
typedef void(^ActiveLocationChangeBlockArgument)(CurrentActiveLocationIndexChangedCallback callback);

typedef LocationInputSwizzlerSettings* _Nonnull (^GetCurrentLocationSettingsCallback)();
