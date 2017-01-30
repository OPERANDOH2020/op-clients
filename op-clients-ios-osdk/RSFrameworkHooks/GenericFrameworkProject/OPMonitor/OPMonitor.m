//
//  OPMonitor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitor.h"
#import "LocationInputSupervisor.h"
#import "NSURLSessionSupervisor.h"
#import "ProximityInputSupervisor.h"
#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI-Swift.h>

@interface OPMonitor() <InputSupervisorDelegate>

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) UIButton *handle;

@property (strong, nonnull) NSArray<InputSourceSupervisor> *supervisorsArray;

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
    self.supervisorsArray = [self buildSupervisors];
}


-(UIView *)getHandle {
    if (self.handle == nil) {
        self.handle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.handle setTitle:@"PP" forState:UIControlStateNormal];
        self.handle.backgroundColor = [UIColor redColor];
        [self.handle addTarget:self action:@selector(didPressHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return  self.handle;
}

-(void)didPressHandle:(id)sender {
    
    OneDocumentRepository *repo = [[OneDocumentRepository alloc] initWithDocument:self.document];
    
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    
    __block UIViewController *vc = nil;
    vc = [CommonUIBUilder buildFlowFor:repo whenExiting:^{
        [rootViewController ppRemoveChildContentController:vc];
    }];
    
    [rootViewController ppAddChildContentController:vc];
}


#pragma mark - 
-(void)newViolationReported:(OPMonitorViolationReport *)report {
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;

    dispatch_async(dispatch_get_main_queue(), ^{
        [UINotificationViewController presentBadNotificationMessage:report.violationDetails inController:rootViewController atDistanceFromTop:22];
    });
}

#pragma mark -

-(NSArray<id<InputSourceSupervisor>>*)buildSupervisors {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *supervisorClasses = @[[LocationInputSupervisor class],
                                   [NSURLSessionSupervisor class],
                                   [ProximityInputSupervisor class]];
    
    for (Class class in supervisorClasses) {
        id supervisor = [[class alloc] init];
        [supervisor reportToDelegate:self analyzingSCD:self.document];
        [result addObject:supervisor];
    }
    
    return  result;
}

@end
