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

@interface UIViolationReportsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<OPMonitorViolationReport*> *reportsArray;
@property (strong, nonatomic) id<OPViolationReportRepository> repository;
@property (strong, nonatomic) void (^exitCallback)();



@property (weak, nonatomic) IBOutlet UILabel *noReportsLabel;

@end

@implementation UIViolationReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView:self.tableView];
    
    self.noReportsLabel.hidden = YES;
    
    [self.repository getAllReportsIn:^(NSArray<OPMonitorViolationReport *> * _Nullable reportsArray, NSError * _Nullable error) {
        self.reportsArray = reportsArray;
        [self.tableView reloadData];
        
        self.noReportsLabel.hidden = reportsArray.count > 0;
        self.tableView.hidden = reportsArray.count == 0;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)setupWithRepository:(id<OPViolationReportRepository>)repository onExit:(void (^)())exitCallback{
    
    self.repository = repository;
    self.exitCallback = exitCallback;
    
    
    [self view];
}

#pragma mark - 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViolationReportCell *cell = [tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    [cell setupWithReport:self.reportsArray[indexPath.row]];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return  NO;
}


#pragma mark -



-(void)setupTableView:(UITableView*)tableView {
    UINib *nib = [UINib nibWithNibName:[ViolationReportCell identifierNibName] bundle:[NSBundle bundleForClass:[self class]]];
    
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
