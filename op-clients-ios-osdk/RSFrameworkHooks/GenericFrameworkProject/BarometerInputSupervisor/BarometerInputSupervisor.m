//
//  BarometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BarometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>


typedef void(^AltimeterCallback)(NSDictionary*);
AltimeterCallback _globalAltimeterCallback;




@interface BarometerInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedSensor *sensor;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;

@end

@implementation BarometerInputSupervisor

-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document{
    self.document = document;
    self.delegate = delegate;
    self.sensor = [CommonUtils extractSensorOfType:SensorType.Barometer from:document.accessedSensors];
}

@end
