//
//  UIViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViolationReportsSection : NSObject

@property (readonly, nonatomic, weak, nullable) UITableView *tableView;
@property (readonly, nonatomic) NSInteger sectionIndex;

-(instancetype __nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView* __nullable)tableView;

-(NSInteger)numberOfRows;
-(UITableViewCell* _Nonnull)cellForRowAtIndex:(NSInteger)index;
-(UIView* _Nullable)sectionHeader;

@end
