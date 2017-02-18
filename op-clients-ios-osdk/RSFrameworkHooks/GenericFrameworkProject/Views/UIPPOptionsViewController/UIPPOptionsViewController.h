//
//  UIPPOptionsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPMonitorSettings.h"

@interface UIPPOptionsViewControllerCallbacks: NSObject

@property (strong, nonatomic) void (^whenChoosingSCDInfo)();
@property (strong, nonatomic) void (^whenChoosingReportsInfo)();
@property (strong, nonatomic) void (^whenExiting)();

@property (strong, nonatomic) void (^whenChoosingViewSCD)();

@end

@interface UIPPOptionsViewController : UIViewController

-(void)setupWithCallbacks:(UIPPOptionsViewControllerCallbacks*)callbacks andMonitorSettings:(OPMonitorSettings*)monitorSettings;

@end
