//
//  LocationInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <JRSwizzle.h>


typedef void (^LocationCallbackWithInfo)(NSDictionary*);
LocationCallbackWithInfo _rsHookGlobalLocationCallback;


@interface LocationInputSupervisor()
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *locationSensor;
@end


@implementation LocationInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    self.delegate = delegate;
    self.document = document;
    self.locationSensor = [CommonUtils extractInputOfType: InputType.Location from:document.accessedInputs];
}


-(void)processLocationStatus:(NSDictionary*)statusDict{
    if (statusDict[kStatusKey]) {
        [self processStatus:[statusDict[kStatusKey] integerValue]];
    }
}

-(void)processStatus:(LocationStatus)locStatus {
    OPMonitorViolationReport *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newViolationReported:report];
    }
}


-(OPMonitorViolationReport*)detectUnregisteredAccess {
    if (self.locationSensor) {
        return nil;
    }
    
    NSDictionary *details = @{kInputTypeReportKey: InputType.Location};
    
    return [[OPMonitorViolationReport alloc] initWithDetails:details violationType:TypeUnregisteredSensorAccessed];
}

@end
