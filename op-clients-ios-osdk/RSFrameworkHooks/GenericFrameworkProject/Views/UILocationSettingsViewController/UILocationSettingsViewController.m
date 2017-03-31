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
    
}

- (IBAction)didPressInsertCoordinatesManually:(id)sender {
    self.locationPinningView.hidden = YES;
    self.locationListView.hidden = NO;
}

- (IBAction)didPressToAddOnMap:(id)sender {
    self.locationPinningView.hidden = NO;
    self.locationListView.hidden = YES;
}




@end
