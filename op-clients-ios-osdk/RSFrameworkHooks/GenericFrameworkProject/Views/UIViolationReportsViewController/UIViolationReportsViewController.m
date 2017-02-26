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

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*,NSArray<OPMonitorViolationReport*> *>* reportsArrayPerType;

@property (strong, nonatomic) id<OPViolationReportRepository> repository;
@property (strong, nonatomic) NSArray<SCDSectionHeaderModel*> *sectionModels;
@property (strong, nonatomic) NSArray<NSNumber*> *currentReportTypes;
@property (strong, nonatomic) void (^exitCallback)();



@property (weak, nonatomic) IBOutlet UILabel *noReportsLabel;

@end

@implementation UIViolationReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noReportsLabel.hidden = YES;
    self.sectionModels = @[];
    [self setupTableView:self.tableView];
}

+(NSArray<SCDSectionHeaderModel*>*)buildSectionHeaderModelsWithDisplayedTypes:(NSArray*)displayedTypes crossCheckingWithAvailableTypes:(NSArray<NSNumber*>*)availableTypes{
    

    NSDictionary* nameForType = @{
                         @(TypeAccessedUnlistedURL) : @"Access unlisted url",
                         @(TypePrivacyLevelViolation): @"Privacy level violation",
                         @(TypeUnregisteredSensorAccessed): @"Access unlisted sensor",
                         @(TypeAccessFrequencyViolation): @"Access frequency violation"
                         };
    

    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSNumber *reportType in displayedTypes) {
        SCDSectionHeaderModel *headerModel = [[SCDSectionHeaderModel alloc] initWithName:nameForType[reportType] expanded:NO enabled:[availableTypes containsObject:reportType]];
        
        [result addObject:headerModel];
    }
    
    return result;
}

-(void)setupWithRepository:(id<OPViolationReportRepository>)repository onExit:(void (^)())exitCallback{
    
    [self view];
    self.repository = repository;
    self.exitCallback = exitCallback;
    self.currentReportTypes = @[@(TypeAccessedUnlistedURL), @(TypePrivacyLevelViolation),
                                @(TypeUnregisteredSensorAccessed), @(TypeAccessFrequencyViolation)];
    self.reportsArrayPerType = [[NSMutableDictionary alloc] init];
    
    [repository getTypesOfReportsIn:^(NSArray<NSNumber *> * _Nullable reportTypes, NSError * _Nullable error) {
        
        self.sectionModels = [UIViolationReportsViewController buildSectionHeaderModelsWithDisplayedTypes:self.currentReportTypes crossCheckingWithAvailableTypes:reportTypes];
        
        [self.tableView reloadData];
        
    }];
}

#pragma mark -

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak typeof(self) weakSelf = self;
    
    SCDSectionHeader *header = [[SCDSectionHeader alloc] init];
    SCDSectionHeaderCallbacks *callbacks = [[SCDSectionHeaderCallbacks alloc] initWithCallToExpand:^(void (^callToConfirmExpand)(BOOL)) {
        [weakSelf showItemsForSectionAtIndex:section withCallback:callToConfirmExpand];
    } callToContract:^(void (^callToConfirmContract)(BOOL)) {
        [weakSelf hideItemsForSectionAtIndex:section];
        SAFECALL(callToConfirmContract, YES);
    }];
    
    [header setupWithModel:self.sectionModels[section] callbacks:callbacks];
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionModels.count;
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

-(void)showItemsForSectionAtIndex:(NSInteger)index withCallback:(void(^)(BOOL))successCallback {
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
            SAFECALL(successCallback, YES);
            return;
        }
        
        SAFECALL(successCallback, NO);
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
