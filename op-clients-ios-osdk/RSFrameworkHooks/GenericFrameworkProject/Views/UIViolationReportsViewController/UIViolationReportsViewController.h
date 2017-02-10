//
//  UIViolationReportsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportsStorageProtocol.h"


@interface UIViolationReportsViewController : UIViewController

-(void)setupWithRepository:(id<OPViolationReportRepository>)repository
                    onExit:(void (^)())exitCallback;

@end
