//
//  UIHostAccessViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIHostAccessViolationReportsSection.h"

@interface UIHostAccessViolationReportsSection()
@property (strong, nonatomic) id<PPUnlistedHostReportsSource> reportsSource;
@property (strong, nonatomic) NSArray<PPAccessUnlistedHostReport*> *reportsArray;
@end

@implementation UIHostAccessViolationReportsSection
-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPUnlistedHostReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    
    return self;
}
@end
