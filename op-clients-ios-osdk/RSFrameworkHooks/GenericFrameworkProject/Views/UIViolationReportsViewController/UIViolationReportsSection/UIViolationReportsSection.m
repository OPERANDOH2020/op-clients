//
//  UIViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIViolationReportsSection.h"

@interface UIViolationReportsSection()
@property (readwrite, weak, nonatomic) UITableView *tableView;
@property (readwrite, assign, nonatomic) NSInteger sectionIndex;
@end

@implementation UIViolationReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView{
    if (self = [super init]) {
        self.sectionIndex = sectionIndex;
        self.tableView = tableView;
    }
    
    return self;
}

// - Intended to be overriden by subclasses
#pragma mark -
-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index {
    return [[UITableViewCell alloc] init];
}

-(NSInteger)numberOfRows {
    return 0;
}

-(UIView *)sectionHeader {
    return nil;
}

@end
