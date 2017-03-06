//
//  UIPrivacyLevelViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIPrivacyLevelViolationReportsSection.h"

@interface UIPrivacyLevelViolationReportsSection()
@property (strong, nonatomic) id<PPPrivacyLevelReportsSource> reportsSource;
@end

@implementation UIPrivacyLevelViolationReportsSection
-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPPrivacyLevelReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    return self;
}
@end
