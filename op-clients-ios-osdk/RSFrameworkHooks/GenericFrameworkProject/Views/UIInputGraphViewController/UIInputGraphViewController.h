//
//  UIInputGraphViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPMonitorViolationReport.h"


@interface UIGraphViewController : UIViewController

-(void)setupWithReports:(NSArray<OPMonitorViolationReport*>* _Nonnull)reports exitCallback:(void (^ __nullable)())exitCallback;

@end
