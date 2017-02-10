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
#import "PedometerInputSupervisor.h"
#import "ContactsInputSupervisor.h"
#import "MicrophoneInputSupervisor.h"
#import "CameraInputSupervisor.h"
#import "TouchIdSupervisor.h"
#import "MagnetometerInputSupervisor.h"
#import "AccelerometerInputSupervisor.h"
#import "BarometerInputSupervisor.h"
#import "InputSupervisorsManager.h"
#import "PlistReportsStorage.h"

#import "PPFlowBuilder.h"

#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI-Swift.h>


@interface OPMonitor() <InputSupervisorDelegate>

@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) UIButton *handle;
@property (strong, nonatomic) id<OPViolationReportRepository> reportsRepository;
@property (strong, nonnull) NSArray<id<InputSourceSupervisor>> *supervisorsArray;

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
    
    [[CommonTypeBuilder sharedInstance] buildSCDDocumentWith:document in: ^void(SCDDocument * _Nullable scdDocument, NSError * _Nullable error) {
        
        if (error || !scdDocument) {
            NSString *errorMessage = @"Could not create the app SCD document!";
            [OPMonitor displayNotification:errorMessage];
            return;
            
        }
        self.reportsRepository = [[PlistReportsStorage alloc] init];
        self.document = scdDocument;
        self.supervisorsArray = [self buildSupervisors];
        [InputSupervisorsManager buildSharedInstanceWithSupervisors:self.supervisorsArray];
    }];
    

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

    __block UIViewController *flowRoot = nil;
    
    PPFlowBuilderModel *flowModel = [[PPFlowBuilderModel alloc] init];
    flowModel.violationReportsRepository = self.reportsRepository;
    flowModel.scdRepository = repo;
    flowModel.onExitCallback = ^{
        [rootViewController ppRemoveChildContentController:flowRoot];
    };
    
    PPFlowBuilder *flowBuilder = [[PPFlowBuilder alloc] init];
    flowRoot = [flowBuilder buildFlowWithModel:flowModel];
    
    [rootViewController ppAddChildContentController:flowRoot];
}


#pragma mark - 
-(void)newViolationReported:(OPMonitorViolationReport *)report {
    [OPMonitor displayNotification:report.violationDetails];
    [self.reportsRepository addReport:report];
}

#pragma mark -

+(void)displayNotification:(NSString*)notification {
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UINotificationViewController presentBadNotificationMessage:notification inController:rootViewController atDistanceFromTop:22];
    });
}

-(NSArray<id<InputSourceSupervisor>>*)buildSupervisors {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *supervisorClasses = @[[LocationInputSupervisor class],
                                   [NSURLSessionSupervisor class],
                                   [ProximityInputSupervisor class],
                                   [PedometerInputSupervisor class],
                                   [MagnetometerInputSupervisor class],
                                   [AccelerometerInputSupervisor class],
                                   [BarometerInputSupervisor class],
                                   [TouchIdSupervisor class],
                                   [CameraInputSupervisor class],
                                   [MicrophoneInputSupervisor class],
                                   [ContactsInputSupervisor class]
                                   ];
    
    for (Class class in supervisorClasses) {
        id supervisor = [[class alloc] init];
        [supervisor reportToDelegate:self analyzingSCD:self.document];
        [result addObject:supervisor];
    }
    
    return  result;
}

@end
