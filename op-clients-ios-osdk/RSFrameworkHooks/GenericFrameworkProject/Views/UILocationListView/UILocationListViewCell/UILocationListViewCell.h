//
//  UILocationListViewCell.h
//  PPCloak
//
//  Created by Costin Andronache on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UILocationListCellUpdateCallback)(double latitude, double longitude);

@interface UILocationListViewCell : UITableViewCell
+(NSString*)identifierNibName;

-(void)setupWithLatitude:(double)latitude longitude:(double)longitude callbackOnUpdate:(UILocationListCellUpdateCallback)callback;

@end
