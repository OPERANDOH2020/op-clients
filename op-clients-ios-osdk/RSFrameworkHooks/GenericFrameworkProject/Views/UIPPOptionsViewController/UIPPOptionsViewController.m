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
@property (strong, nonatomic) UIPPOptionsViewControllerCallbacks *callbacks;
@end

@implementation UIPPOptionsViewController

-(void)setupWithCallbacks:(UIPPOptionsViewControllerCallbacks *)callbacks {
    self.callbacks = callbacks;
}

- (IBAction)didPressViewAppDetails:(id)sender {
    SAFECALL(self.callbacks.whenChoosingSCDInfo)
    
}

- (IBAction)didPressViewViolationReports:(id)sender {
    
    SAFECALL(self.callbacks.whenChoosingReportsInfo)
}


- (IBAction)didPressClose:(id)sender {
    SAFECALL(self.callbacks.whenExiting)
}
- (IBAction)didPressViewSCD:(id)sender {
    SAFECALL(self.callbacks.whenChoosingViewSCD)
}

@end
