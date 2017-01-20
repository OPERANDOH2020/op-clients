//
//  OPMonitor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitor.h"
#import "LocationInputSupervisor.h"
#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI-Swift.h>

@interface OPMonitor() <InputSupervisorDelegate>

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) UIButton *handle;
@end

@implementation OPMonitor

+(instancetype)sharedInstance{
    static OPMonitor *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[OPMonitor alloc] init];
    });
    
    return  shared;
}

-(void)beginMonitoringWithAppDocument:(NSDictionary *)document {
    self.document = [[SCDDocument alloc] initWithScd:document];
}


-(UIView *)getHandle {
    if (self.handle == nil) {
        self.handle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.handle setTitle:@"PP" forState:UIControlStateNormal];
        
        [self.handle addTarget:self action:@selector(didPressHandle:) forControlEvents:UIControlEventAllTouchEvents];
    }
    
    return  self.handle;
}




-(void)didPressHandle:(id)sender {
    OneDocumentRepository *repo = [[OneDocumentRepository alloc] init];
    
    UIViewController *vc = [CommonUIBUilder buildFlowFor:[OneDocumentRepository alloc]] whenExiting:<#^(void)whenExiting#>
}


#pragma mark - 
-(void)newViolationReported:(OPMonitorViolationReport *)report {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PlusPrivacy" message:report.violationDetails delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

@end
