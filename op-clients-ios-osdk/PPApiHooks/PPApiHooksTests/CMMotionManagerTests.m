//
//  CMMotionManagerTests.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMMotionManager+PPHOOK.h"
#import "TestDispatcher.h"
#import "CommonBaseTest.h"

@interface CMMotionManagerTests : CommonBaseTest
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

@implementation CMMotionManagerTests

- (void)setUp {
    [super setUp];
    if (!self.motionManager) {
        self.motionManager = [[CMMotionManager alloc] init];
        id motionManagerClass = [CMMotionManager class];
        CALL_PREFIXED(motionManagerClass, setEventsDispatcher:self.testDispatcher);
    }
}


-(void)testSetAccelerometerUpdateInterval_keepsCorrectValueAndIdentifiers {
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        XCTestExpectation *expectation = [self expectationWithDescription:@"Expected values to be present on the event"];
        
        __Weak(self);
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerAccelerometerUpdateIntervalValue]];
            
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetAccelerometerUpdateInterval)];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerAccelerometerUpdateIntervalValue] doubleValue]), @"Expected update value from event data to be the same as updateInterval!");
            
            
            [expectation fulfill];
        };
        
        self.motionManager.accelerometerUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    };
    execution(1);
    execution(8);
    execution(1003);
}

-(void)testSetAccelerometerUpdateInterval_setsModifiedValue {    
    void(^execution)(NSTimeInterval, NSTimeInterval) = ^void(NSTimeInterval firstUpdateInterval, NSTimeInterval modifiedValue){
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerAccelerometerUpdateIntervalValue] = @(modifiedValue);
            void(^confirmation)()  = event.eventData[kPPConfirmationCallbackBlock];
            confirmation();
        };
        
        self.motionManager.accelerometerUpdateInterval = firstUpdateInterval;
        XCTAssert(doublesApproximatelyEqual(modifiedValue, self.motionManager.accelerometerUpdateInterval), @"Expected to set modified value!");
    };
    
    execution(1, 5);
    execution(14, 10);
    execution(5, 100);
}


-(void)testSetGyroUpdateInterval_keepsCorrectValuesAndIdentifier{
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        __Weak(self);
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        
        
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetGyroUpdateInterval)];
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerGyroUpdateIntervalValue]];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerGyroUpdateIntervalValue] doubleValue]));
            [expectation fulfill];
        };
        
        self.motionManager.gyroUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    };
    
    execution(10);
    execution(7);
    execution(10024);
}


-(void)testSetGyroUpdateInterval_setsModifiedValue{
    
    void (^execution)(NSTimeInterval initialInterval, NSTimeInterval modifiedInterval) = ^void(NSTimeInterval initialInterval, NSTimeInterval modifiedInterval){
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerGyroUpdateIntervalValue] = @(modifiedInterval);
            void (^confirmation)() = event.eventData[kPPConfirmationCallbackBlock];
            confirmation();
        };
        
        self.motionManager.gyroUpdateInterval = initialInterval;
        XCTAssert(doublesApproximatelyEqual(self.motionManager.gyroUpdateInterval, modifiedInterval));
    };
    
    execution(10, 3);
    execution(3, 10);
    execution(18, 29);
}


-(void)testSetMagnetometerDeviceUpdateInterval_keepsCorrectValueAndIdentifier {
    
    void(^execution)(NSTimeInterval) = ^void(NSTimeInterval updateInterval){
        __Weak(self);
        
        XCTestExpectation *expectation = [self expectationWithDescription:@""];
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            [weakself assertIdentifier:event.eventIdentifier equals:PPEventIdentifierMake(PPMotionManagerEvent, EventMotionManagerSetMagnetometerUpdateInterval)];
            [weakself assertDictionary:event.eventData containsValuesForKeys:@[kPPConfirmationCallbackBlock, kPPMotionManagerMagnetometerUpdateIntervalValue]];
            
            weak_XCTAssert(doublesApproximatelyEqual(updateInterval, [event.eventData[kPPMotionManagerMagnetometerUpdateIntervalValue] doubleValue]));
            
            [expectation fulfill];
        };
        
        self.motionManager.magnetometerUpdateInterval = updateInterval;
        [self waitForExpectationsWithTimeout:4.0 handler:nil];
    };
    
    execution(4);
    execution(1003);
    execution(20);
}

-(void)testSetMagnetometerDeviceUpdateInterval_setsModifiedValue{
    
    void(^execution)(NSTimeInterval, NSTimeInterval) = ^void(NSTimeInterval initialValue, NSTimeInterval modifiedValue) {
        self.testDispatcher.testEventHandler = ^void(PPEvent *event){
            event.eventData[kPPMotionManagerMagnetometerUpdateIntervalValue] = @(modifiedValue);
            void(^confBlock)() = event.eventData[kPPConfirmationCallbackBlock];
            confBlock();
        };
        
        self.motionManager.magnetometerUpdateInterval = initialValue;
        XCTAssert(doublesApproximatelyEqual(modifiedValue, self.motionManager.magnetometerUpdateInterval));
    };
    
    execution(1, 5);
    execution(100, 3);
    execution(77, 5445);
}

@end
