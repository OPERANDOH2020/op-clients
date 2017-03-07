//
//  UIInputAccessViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIInputAccessViolationReportsSection.h"
#import "Common.h"

@interface UIInputAccessViolationReportsSection()
@property (strong, nonatomic) id<PPUnlistedInputReportsSource> reportsSource;
@end

@implementation UIInputAccessViolationReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView inputAccessReportsSource:(id<PPUnlistedInputReportsSource>)source {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = source;
    }
    return self;
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getUnlistedInputReportsIn:^(NSArray<PPUnlistedInputAccessViolation *> * _Nullable reports, NSError * _Nullable error ) {
        self.reportsArray = reports;
        SAFECALL(completion)
    }];
}



@end
