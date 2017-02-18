//
//  UIPPOptionsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIPPOptionsViewController.h"
#import "Common.h"

@implementation UIPPOptionsViewControllerCallbacks
@end

@interface UIPPOptionsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (strong, nonatomic) UIPPOptionsViewControllerCallbacks *callbacks;
@property (strong, nonatomic) OPMonitorSettings *monitorSettings;
@end

@implementation UIPPOptionsViewController

-(void)setupWithCallbacks:(UIPPOptionsViewControllerCallbacks *)callbacks andMonitorSettings:(OPMonitorSettings *)monitorSettings {
    self.callbacks = callbacks;
    self.monitorSettings = monitorSettings;
    
    [self view];
    self.notificationsSwitch.on = monitorSettings.allowNotifications;
}

- (IBAction)didPressViewAppDetails:(id)sender {
    SAFECALL(self.callbacks.whenChoosingSCDInfo)
    
}

- (IBAction)didPressViewViolationReports:(id)sender {
    
    SAFECALL(self.callbacks.whenChoosingReportsInfo)
}

- (IBAction)didChangeSwitchValue:(id)sender {
    self.monitorSettings.allowNotifications = self.notificationsSwitch.on;
}

- (IBAction)didPressClose:(id)sender {
    SAFECALL(self.callbacks.whenExiting)
}
- (IBAction)didPressViewSCD:(id)sender {
    SAFECALL(self.callbacks.whenChoosingViewSCD)
}

@end
