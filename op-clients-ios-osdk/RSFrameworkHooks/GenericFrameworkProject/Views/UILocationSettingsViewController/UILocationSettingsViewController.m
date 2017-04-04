//
//  UILocationSettingsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationSettingsViewController.h"
#import "Common.h"
#import "UILocationListView.h"
#import "UILocationPinningView.h"

#pragma mark -
@interface NSString(UILocationSettingsViewController)
-(NSNumber*)toNumber;
@end

@implementation NSString(UILocationSettingsViewController)

-(NSNumber *)toNumber{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    return [nf numberFromString:self];
}

@end

#pragma mark -

@implementation LocationSettingsModel
@end

@interface UILocationSettingsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) void(^_Nullable onExitCallback)();
@property (strong, nonatomic) LocationSettingsModel *model;

@property (weak, nonatomic) IBOutlet UILocationListView *locationListView;

@property (weak, nonatomic) IBOutlet UILocationPinningView *locationPinningView;
@end



@implementation UILocationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationPinningView.hidden = YES;
}

-(void)setupWithModel:(LocationSettingsModel *)model onExit:(void (^)())exitCallback {
    [self view];
    
    self.model = model;
    self.onExitCallback = exitCallback;
    
    UILocationPinningViewCallbacks *locationPinningViewCallbacks = [self createLocationPinningViewCallbacks];
    UILocationListViewCallbacks *locationListViewCallbacks = [self createLocationListCallbacks];
    
    [self.locationListView setupWithInitialList:model.currentSettings.locations callbacks:locationListViewCallbacks];
    [self.locationPinningView setupWithLocations:model.currentSettings.locations callbacks:locationPinningViewCallbacks];
    
}


-(UILocationListViewCallbacks*)createLocationListCallbacks{
    WEAKSELF
    UILocationListViewCallbacks *callbacks = [[UILocationListViewCallbacks alloc] init];
    callbacks.onNewLocationAdded = ^void(CLLocation *location){
        [weakSelf.locationPinningView addNewLocation:location];
    };
    
    callbacks.onDeleteAll = ^void() {
        [weakSelf.locationPinningView clearAll];
    };
    
    callbacks.onDeleteLocationAtIndex = ^void(NSInteger index){
        [weakSelf.locationPinningView deleteLocationAt:index];
    };
    
    callbacks.onModifyLocationAtIndex = ^void(CLLocation *location, NSInteger index){
        [weakSelf.locationPinningView modifyLocationAt:index toLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    };
    return callbacks;
}

-(UILocationPinningViewCallbacks*)createLocationPinningViewCallbacks{
    UILocationPinningViewCallbacks *callbacks = [[UILocationPinningViewCallbacks alloc] init];
    WEAKSELF
    callbacks.onNewLocationAdded = ^void(CLLocation *location){
        [weakSelf.locationListView addNewLocation:location];
    };
    
    callbacks.onDeleteLocationAtIndex = ^void(NSInteger index){
        [weakSelf.locationListView removeLocationAt:index];
    };
    
    callbacks.onModifyLocationAtIndex = ^void(CLLocation *location, NSInteger index){
        [weakSelf.locationListView modifyLocationAt:index to:location];
    };
    return callbacks;
}

- (IBAction)didPressInsertCoordinatesManually:(id)sender {
    self.locationPinningView.hidden = YES;
    self.locationListView.hidden = NO;
}

- (IBAction)didPressToAddOnMap:(id)sender {
    self.locationPinningView.hidden = NO;
    self.locationListView.hidden = YES;
}

- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.onExitCallback)
}

- (IBAction)didPressSave:(id)sender {
    LocationInputSwizzlerSettings *newSettings = [self compileSettings];
    SAFECALL(self.model.saveCallback, newSettings)
}

-(LocationInputSwizzlerSettings*)compileSettings {
    return [LocationInputSwizzlerSettings createWithLocations:self.locationListView.currentLocations enabled:YES cycle:YES changeInterval:5.0];
}

@end
