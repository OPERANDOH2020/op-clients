//
//  UIViolationReportsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIViolationReportsViewController.h"
#import "ViolationReportCell.h"
#import "Common.h"
#import "NSBundle+RSFrameworkHooks.h"
#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI.h>


@interface UIViolationReportsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *nameForType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*,NSArray<OPMonitorViolationReport*> *>* reportsArrayPerType;
@property (strong, nonatomic) id<OPViolationReportRepository> repository;

@property (strong, nonatomic) NSArray<NSNumber*> *currentReportTypes;

@property (strong, nonatomic) void (^exitCallback)();



@property (weak, nonatomic) IBOutlet UILabel *noReportsLabel;

@end

@implementation UIViolationReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameForType = @{
        @(TypeAccessedUnlistedURL) : @"Access unlisted url",
        @(TypePrivacyLevelViolation): @"Privacy level violation",
        @(TypeUnregisteredSensorAccessed): @"Access unlisted input",
        @(TypePrivacyLevelViolation): @"Privacy level violation"
        };
    
    self.reportsArrayPerType = [[NSMutableDictionary alloc] init];
    
    [self setupTableView:self.tableView];
    self.noReportsLabel.hidden = YES;
    
    [self.repository getTypesOfReportsIn:^(NSArray<NSNumber *> * _Nullable types, NSError * _Nullable error) {
        
        self.currentReportTypes = types;
        self.noReportsLabel.hidden = self.currentReportTypes.count > 0;
        [self.tableView reloadData];
    }];
}


-(void)setupWithRepository:(id<OPViolationReportRepository>)repository onExit:(void (^)())exitCallback{
    
    self.repository = repository;
    self.exitCallback = exitCallback;
    
    
    [self view];
}

#pragma mark - 

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // meh, later the header will be dequeued
    NSString *title = self.nameForType[self.currentReportTypes[section]];
    if (!title) {
        title = @"Unknown title";
    }
    __weak typeof(self) weakSelf = self;
    
    SCDSectionHeader *header = [[SCDSectionHeader alloc] init];
    SCDSectionHeaderCallbacks *callbacks = [[SCDSectionHeaderCallbacks alloc] initWithCallToExpand:^{
        [weakSelf showItemsForSectionAtIndex:section];
    } callToContract:^{
        [weakSelf hideItemsForSectionAtIndex:section];
    }];
    
    [header setupWithTitle:title callbacks:callbacks];
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.currentReportTypes.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportsArrayPerType[self.currentReportTypes[section]].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViolationReportCell *cell = [tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    NSArray *reportsArray = self.reportsArrayPerType[self.currentReportTypes[indexPath.section]];
    [cell setupWithReport:reportsArray[indexPath.row]];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return  NO;
}


#pragma mark -

-(void)showItemsForSectionAtIndex:(NSInteger)index {
    OPMonitorViolationType type = self.currentReportTypes[index].integerValue;
    [self.repository getAllReportsOfType:type in:^(NSArray<OPMonitorViolationReport *> * _Nullable reports, NSError * _Nullable error) {
        if (reports) {
            self.reportsArrayPerType[@(type)] = reports;
        }
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for(int i=0; i<reports.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
        if (indexPaths.count) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

-(void)hideItemsForSectionAtIndex:(NSInteger)index {
    
    NSArray *reports = self.reportsArrayPerType[self.currentReportTypes[index]];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for(int i=0; i<reports.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:index]];
    }
    
    self.reportsArrayPerType[self.currentReportTypes[index]] = nil;
    
    if (indexPaths.count) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)setupTableView:(UITableView*)tableView {
    
    NSBundle *bundle = [NSBundle frameworkHooksBundle];
    UINib *nib = [UINib nibWithNibName:[ViolationReportCell identifierNibName] bundle:
                  bundle];
    
    [tableView registerNib:nib forCellReuseIdentifier:[ViolationReportCell identifierNibName]];
    
    tableView.estimatedRowHeight = 80;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (IBAction)backButtonPressed:(id)sender {
    SAFECALL(self.exitCallback)
}

@end
