//
//  UILocationListView.m
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationListView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSBundle+RSFrameworkHooks.h"
#import "UILocationListViewCell.h"
#import "Common.h"


@implementation UILocationListViewCallbacks
@end

@interface UILocationListView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (readwrite, strong, nonatomic) NSMutableArray<CLLocation*> *allLocations;
@property (strong, nonatomic) UILocationListViewCallbacks *callbacks;
@end

@implementation UILocationListView

-(void)commonInit {
    [super commonInit];
    self.allLocations = [[NSMutableArray alloc] init];
    [self setupTableView];
}

-(void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:[UILocationListViewCell identifierNibName] bundle:[NSBundle PPCloakBundle]];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:[UILocationListViewCell identifierNibName]];
    
    self.tableView.rowHeight = 70;
}


-(void)setupWithInitialList:(NSArray<CLLocation *> *)initialLocations callbacks:(UILocationListViewCallbacks *)callbacks {
    if (initialLocations) {
        [self.allLocations addObjectsFromArray:initialLocations];
    }
    self.callbacks = callbacks;
}

-(void)addNewLocation:(CLLocation *)location {
    [self.allLocations addObject:location];
    [self.tableView reloadData];
}

-(void)removeLocationAt:(NSInteger)index {
    [self.allLocations removeObjectAtIndex:index];
    [self.tableView reloadData];
}

-(void)modifyLocationAt:(NSInteger)index to:(CLLocation *)location{
    [self.allLocations replaceObjectAtIndex:index withObject:location];
    [self.tableView reloadData];
}

#pragma mark - 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILocationListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UILocationListViewCell identifierNibName]];
    
    CLLocationCoordinate2D coord = self.allLocations[indexPath.row].coordinate;
    __weak typeof(self) weakSelf = self;
    __weak UILocationListViewCell *weakCell = cell;

    
    UILocationListViewCellCallbacks *callbacks = [[UILocationListViewCellCallbacks alloc] init];
    callbacks.onCoordinatesUpdate = ^void(double latitude, double longitude) {
        NSIndexPath *idxPath = [weakSelf.tableView indexPathForCell:weakCell];

        CLLocation *locaton = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [weakSelf.allLocations replaceObjectAtIndex:idxPath.row withObject:locaton];
        SAFECALL(weakSelf.callbacks.onModifyLocationAtIndex, locaton, indexPath.row)
    };
    
    callbacks.onDelete = ^void() {
        NSIndexPath *idxPath = [weakSelf.tableView indexPathForCell:weakCell];
        if (idxPath) {
            [weakSelf.allLocations removeObjectAtIndex:idxPath.row];
            [weakSelf.tableView reloadData];
            SAFECALL(weakSelf.callbacks.onDeleteLocationAtIndex, idxPath.row)
        }
    };
    
    [cell setupWithLatitude:coord.latitude longitude:coord.longitude index:indexPath.row+1 callbacks:callbacks];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - 

- (IBAction)didPressDeleteAll:(id)sender {
    [self.allLocations removeAllObjects];
    [self.tableView reloadData];
    SAFECALL(self.callbacks.onDeleteAll)
}


- (IBAction)didPressAdd:(id)sender {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    [self.allLocations addObject:location];
    [self.tableView reloadData];
    SAFECALL(self.callbacks.onNewLocationAdded, location)
}

-(NSArray<CLLocation *> *)currentLocations {
    return [NSArray arrayWithArray:self.allLocations];
}

@end
