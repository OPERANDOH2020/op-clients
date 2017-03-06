//
//  UIInputAccessViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIInputAccessViolationReportsSection.h"

@interface UIInputAccessViolationReportsSection()
@property (strong, nonatomic) id<PPUnlistedInputReportsSource> reportsSource;
@property (strong, nonatomic) NSArray<PPUnlistedInputAccessViolation*> *reportsArray;
@end

@implementation UIInputAccessViolationReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView inputAccessReportsSource:(id<PPUnlistedInputReportsSource>)source {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = source;
    }
    return self;
}

-(NSInteger)numberOfRows {
    return  self.reportsArray.count;
}



@end
