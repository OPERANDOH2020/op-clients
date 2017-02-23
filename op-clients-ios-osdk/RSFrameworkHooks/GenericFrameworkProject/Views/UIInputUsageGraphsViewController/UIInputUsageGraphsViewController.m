//
//  UIInputUsageGraphsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIInputUsageGraphsViewController.h"
#import "Common.h"
#import "CommonReportKeys.h"

@implementation UIInputUsageGraphsCallbacks
@end

@interface UIInputUsageGraphsViewController ()
@property (strong, nonatomic) id<OPViolationReportRepository> repository;
@property (strong, nonatomic) UIInputUsageGraphsCallbacks *callbacks;
@property (strong, nonatomic) NSArray<NSString*> *availableInputTypes;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UIInputUsageGraphsViewController

-(void)setupWithRepository:(id<OPViolationReportRepository>)repository andCallbacks:(UIInputUsageGraphsCallbacks *)callbacks {
    [self view];
    
    self.callbacks = callbacks;
    self.repository = repository;
    
    [repository getCurrentInputTypesInViolationReportsIn:^(NSArray<NSString *> * _Nullable types, NSError * _Nullable error) {
        
        self.availableInputTypes = types;
        if (types.count) {
            [self.tableView reloadData];
        } else {
            self.titleLabel.text = @"No reports available";
        }
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableInputTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicTitleCell"];
    NSString *inputType = self.availableInputTypes[indexPath.row];
    NSString *inputName = InputType.namesPerInputType[inputType];
    cell.textLabel.text = inputName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *inputType = self.availableInputTypes[indexPath.row];
    SAFECALL(self.callbacks.inputTypeSelectedCallback, inputType);
}
- (IBAction)didPressBackButton:(id)sender {
    SAFECALL(self.callbacks.exitCallback)
}

@end
