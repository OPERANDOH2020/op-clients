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
#import "JRSwizzle.h"
#import "LocationInputSwizzler.h"

#import "PPFlowBuilder.h"


#import <PlusPrivacyCommonUI/PlusPrivacyCommonUI-Swift.h>

@interface NSArray(FindObjectOfClass)
-(id _Nullable)firstObjectOfClass:(Class)class;
@end

@implementation NSArray(FindObjectOfClass)

-(id)firstObjectOfClass:(Class)class{
    for (id obj in self) {
        if ([obj isKindOfClass:class]) {
            return obj;
        }
    }
    return nil;
}

@end

@interface OPMonitor() <InputSupervisorDelegate>

@property (strong, nonatomic) OPMonitorSettings *monitorSettings;
@property (strong, nonatomic) NSDictionary *scdJson;
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) UIButton *handle;
@property (strong, nonatomic) PlistReportsStorage *plistRepository;
@property (strong, nonnull) NSArray<id<InputSourceSupervisor>> *supervisorsArray;

@end

@implementation OPMonitor


static void displayMessage(NSString* message){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alertView show];
    });
}

static void __attribute__((constructor)) initialize(void){
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppSCD" ofType:@"json"];
    NSString *fileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [fileText dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (json) {
        [[OPMonitor sharedInstance] beginMonitoringWithAppDocument:json];
    } else {
        NSString *message = [NSString stringWithFormat:@"Could not find json document at path %@ or fileText is wrong: %@", fileText, path];
        displayMessage(message);
    }
    
}

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
            NSString *errorMessage = [error description];
            displayMessage(errorMessage);
            [self displayNotificationIfPossible:errorMessage];
            return;
            
        }
        
        self.monitorSettings = [[OPMonitorSettings alloc] initFromDefaults];
        self.scdJson = document;
        self.plistRepository = [[PlistReportsStorage alloc] init];
        self.document = scdDocument;
        self.supervisorsArray = [self buildSupervisors];
        LocationInputSupervisor *locSupervisor = [self.supervisorsArray firstObjectOfClass:[LocationInputSupervisor class]];
        [self setupLocationInputSwizzlerUsingSupervisor:locSupervisor];
        
        [InputSupervisorsManager buildSharedInstanceWithSupervisors:self.supervisorsArray];
    }];
    

}


-(UIButton *)getHandle {
    if (self.handle == nil) {
        self.handle = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 44)];
        [self.handle setTitle:@"PP" forState:UIControlStateNormal];
        self.handle.backgroundColor = [UIColor redColor];
        [self.handle addTarget:self action:@selector(didPressHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return  self.handle;
}

-(void)didPressHandle:(id)sender {
    [self displayFlowIfNecessary];
}

-(void)displayFlowIfNecessary {
    
    static BOOL isFlowDisplayed = NO;
    
    if (isFlowDisplayed) {
        return;
    }
    OneDocumentRepository *repo = [[OneDocumentRepository alloc] initWithDocument:self.document];
    
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    __block UIViewController *flowRoot = nil;
    
    LocationSettingsModel *locSettingsModel = [[LocationSettingsModel alloc] init];
    locSettingsModel.currentSettings = [LocationInputSwizzler sharedInstance].currentSettings;
    locSettingsModel.saveCallback = ^void(LocationInputSwizzlerSettings *settings) {
        [[LocationInputSwizzler sharedInstance] applySettings:settings];
        [settings synchronizeToUserDefaults];
    };
    
    PPReportsSourcesBundle *reportSources = [[PPReportsSourcesBundle alloc] init];
    reportSources.accessFrequencyReportsSource = self.plistRepository;
    reportSources.privacyViolationReportsSource = self.plistRepository;
    reportSources.unlistedHostReportsSource = self.plistRepository;
    reportSources.unlistedInputReportsSource = self.plistRepository;
    
    PPFlowBuilderModel *flowModel = [[PPFlowBuilderModel alloc] init];
    flowModel.monitoringSettings = self.monitorSettings;
    flowModel.reportSources = reportSources;
    flowModel.scdRepository = repo;
    flowModel.scdJSON = self.scdJson;
    flowModel.locationSettingsModel = locSettingsModel;
    
    flowModel.onExitCallback = ^{
        [rootViewController ppRemoveChildContentController:flowRoot];
        isFlowDisplayed = NO;
    };
    
    PPFlowBuilder *flowBuilder = [[PPFlowBuilder alloc] init];
    flowRoot = [flowBuilder buildFlowWithModel:flowModel];
    
    isFlowDisplayed = YES;
    [rootViewController ppAddChildContentController:flowRoot];
}

#pragma mark - Reports from input supervisors

-(void)newURLHostViolationReported:(PPAccessUnlistedHostReport *)report {
    [self.plistRepository addUnlistedHostReport:report withCompletion:nil];
    NSString *notification = [NSString stringWithFormat:@"Accessed unlisted host %@", report.urlHost];
    [self displayNotificationIfPossible:notification];
}

-(void)newUnlistedInputAccessViolationReported:(PPUnlistedInputAccessViolation *)report {
    [self.plistRepository addUnlistedInputReport:report withCompletion:nil];
    NSString *notification = [NSString stringWithFormat:@"Accessed unlisted input %@", InputType.namesPerInputType[report.inputType]];
    [self displayNotificationIfPossible:notification];

}


-(void)newPrivacyLevelViolationReported:(PPPrivacyLevelViolationReport *)report {
    // must complete later
}

-(void)newAccessFrequencyViolationReported:(PPAccessFrequencyViolationReport *)report{
    // must complete later
}


#pragma mark -

-(void)displayNotificationIfPossible:(NSString*)notification {
    if (!self.monitorSettings.allowNotifications) {
        return;
    }
    
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UINotificationViewController presentBadNotificationMessage:notification inController:rootViewController atDistanceFromTop:22];
    });
}

-(NSArray<id<InputSourceSupervisor>>*)buildSupervisors {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    // set up the network supervisor separately
    // as it will report url requests to the other supervisors also
    //

    NSURLSessionSupervisor *urlSessionSupervisor = [[NSURLSessionSupervisor alloc] init];

    [urlSessionSupervisor reportToDelegate:self analyzingSCD:self.document];
    [result addObject:urlSessionSupervisor];
    
    NSArray *supervisorClasses = @[[LocationInputSupervisor class],
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
    
    NSMutableArray *networkAnalyzers = [[NSMutableArray alloc] init];
    for (Class class in supervisorClasses) {
        id supervisor = [[class alloc] init];
        [supervisor reportToDelegate:self analyzingSCD:self.document];
        [networkAnalyzers addObject:supervisor];
        [result addObject:supervisor];
    }
    
    [urlSessionSupervisor reportRequestsToAnalyzers:networkAnalyzers];
    
    return  result;
}

-(void)setupLocationInputSwizzlerUsingSupervisor:(LocationInputSupervisor*)supervisor {
    LocationInputSwizzlerSettings *defaultLocationSettings = [LocationInputSwizzlerSettings createFromUserDefaults];
    [[LocationInputSwizzler sharedInstance] applySettings:defaultLocationSettings];
    [[LocationInputSwizzler sharedInstance] reportInputToAnalyzer:supervisor];
}

@end
