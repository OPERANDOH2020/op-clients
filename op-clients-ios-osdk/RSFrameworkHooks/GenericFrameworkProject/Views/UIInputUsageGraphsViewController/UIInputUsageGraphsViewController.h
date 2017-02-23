//
//  UIInputUsageGraphsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportsStorageProtocol.h"

@interface UIInputUsageGraphsCallbacks : NSObject
@property (strong, nonatomic) void (^__nullable exitCallback)();
@property (strong, nonatomic) void (^ __nullable inputTypeSelectedCallback)(NSString* _Nonnull inputType);

@end

@interface UIInputUsageGraphsViewController : UITableViewController

-(void)setupWithRepository:(id<OPViolationReportRepository> __nullable)repository andCallbacks:(UIInputUsageGraphsCallbacks* _Nullable)callbacks;

@end
