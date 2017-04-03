//
//  UILocationListViewCell.h
//  PPCloak
//
//  Created by Costin Andronache on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

typedef void(^UILocationListCellUpdateCallback)(double latitude, double longitude);

@interface UILocationListViewCellCallbacks : NSObject
@property (strong, nonatomic) void(^onCoordinatesUpdate)(double latitude, double longitude);
@property (strong, nonatomic) void(^onDelete)();

@end

@interface UILocationListViewCell: MGSwipeTableCell
+(NSString*)identifierNibName;

-(void)setupWithLatitude:(double)latitude longitude:(double)longitude index:(NSInteger)index callbacks:(UILocationListViewCellCallbacks*)callbacks;


@end
