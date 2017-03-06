//
//  UIAccessFrequencyViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIAccessFrequencyViolationReportsSection.h"

@interface UIAccessFrequencyViolationReportsSection()

@property (strong, nonatomic) id<PPAccessFrequencyReportsSource> reportsSource;
@property (strong, nonatomic) NSArray<PPAccessFrequencyViolationReport*> *reportsArray;

@end

@implementation UIAccessFrequencyViolationReportsSection
-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPAccessFrequencyReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    
    return self;
}
@end
