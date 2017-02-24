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
@property (strong, nonatomic) NSArray<OPMonitorViolationReport*> *unregisterdURLReports;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UIInputUsageGraphsViewController

-(void)setupWithRepository:(id<OPViolationReportRepository>)repository andCallbacks:(UIInputUsageGraphsCallbacks *)callbacks {
    
    self.callbacks = callbacks;
    self.repository = repository;
    
    __weak UITableView *weakTableView = self.tableView;
    
    [repository getCurrentInputTypesInViolationReportsIn:^(NSArray<NSString *> * _Nullable types, NSError * _Nullable error) {
        
        [repository getAllReportsOfType:TypeAccessedUnlistedURL in:^(NSArray<OPMonitorViolationReport *> * _Nullable reports, NSError * _Nullable error) {
            
            self.unregisterdURLReports = reports;
            self.availableInputTypes = types;
            if (types.count || reports.count) {
                [weakTableView reloadData];
            } else {
                self.titleLabel.text = @"No reports available";
            }

        }];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sections = 0;
    if (self.availableInputTypes.count > 0) {
        sections++;
    }
    
    if (self.unregisterdURLReports.count > 0) {
        sections++;
    }
    
    return sections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.unregisterdURLReports.count) {
        return 1;
    }
    return self.availableInputTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicTitleCell"];
    
    if (indexPath.section == 0 && self.unregisterdURLReports.count) {
        cell.textLabel.text = @"Unregistered URL Access";
        return cell;
    }
    
    NSString *inputType = self.availableInputTypes[indexPath.row];
    NSString *inputName = InputType.namesPerInputType[inputType];
    cell.textLabel.text = inputName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && self.unregisterdURLReports.count) {
        SAFECALL(self.callbacks.networkReportsSelectedCallback, self.unregisterdURLReports)
        return;
    }
    
    NSString *inputType = self.availableInputTypes[indexPath.row];
    SAFECALL(self.callbacks.inputTypeSelectedCallback, inputType);
}
- (IBAction)didPressBackButton:(id)sender {
    SAFECALL(self.callbacks.exitCallback)
}

@end
