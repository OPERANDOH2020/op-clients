//
//  UILocationSettingsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInputSwizzlerSettings.h"

typedef void(^LocationSettingsChangedCallback)(LocationInputSwizzlerSettings* _Nullable);


@interface LocationSettingsModel: NSObject

@property (strong, nonatomic) LocationSettingsChangedCallback _Nullable saveCallback;
@property (strong, nonatomic) LocationInputSwizzlerSettings * _Nullable currentSettings;

@end

@interface UILocationSettingsViewController : UIViewController

-(void)setupWithModel:(LocationSettingsModel* _Nullable)model onExit:(void(^ _Nullable)())exitCallback;

@end
