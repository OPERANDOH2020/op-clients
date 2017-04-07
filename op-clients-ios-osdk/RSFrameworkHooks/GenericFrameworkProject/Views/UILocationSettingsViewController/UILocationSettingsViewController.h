//
//  UILocationSettingsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefinedLocationsSwizzlerSettings.h"
#import "CommonLocationViewModels.h"

typedef void(^LocationSettingsChangedCallback)(UserDefinedLocationsSwizzlerSettings* _Nullable);


@interface LocationSettingsModel: NSObject

@property (strong, nonatomic) LocationSettingsChangedCallback _Nullable saveCallback;
@property (strong, nonatomic) GetCurrentLocationSettingsCallback getCallback;

@end

@interface UILocationSettingsViewController : UIViewController

-(void)setupWithModel:(LocationSettingsModel* _Nullable)model onExit:(void(^ _Nullable)())exitCallback;

@end
