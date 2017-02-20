//
//  UILocationSettingsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationSettingsViewController.h"
#import "Common.h"

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
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;

@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTF;
@property (strong, nonatomic) void(^_Nullable onExitCallback)();

@property (strong, nonatomic) LocationSettingsModel *model;
@end



@implementation UILocationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.latitudeTF.delegate = self;
    self.longitudeTF.delegate = self;
    self.enabledSwitch.on = self.model.currentSettings.enabled;
}


-(void)setupWithModel:(LocationSettingsModel*)model onExit:(void(^ _Nullable)())exitCallback {
    [self view];
    self.model = model;
    
    self.latitudeTF.text = [NSString stringWithFormat:@"%.4f", model.currentSettings.locationLatitude];
    self.longitudeTF.text = [NSString stringWithFormat:@"%.4f", model.currentSettings.locationLongitude];
}

- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.onExitCallback)
}

- (IBAction)didPressSave:(id)sender {
    [self validateAndSave];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textField endEditing:YES];
    });
    
    return YES;
}

-(void)validateAndSave {
    NSString *errorMessage = @"Invalid number!";
    
    NSNumber *latitude = [self.latitudeTF.text toNumber];
    if (!latitude) {
        self.latitudeTF.text = errorMessage;
        return;
    }
    
    NSNumber *longitude = [self.longitudeTF.text toNumber];
    if (!longitude) {
        self.longitudeTF.text = errorMessage;
        return;
    }
    
    LocationInputSwizzlerSettings *settings = [LocationInputSwizzlerSettings createWithLatitude:latitude.doubleValue longitude:longitude.doubleValue enabled:self.enabledSwitch.on];
    
    SAFECALL(self.model.saveCallback, settings)
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Done" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}





@end
