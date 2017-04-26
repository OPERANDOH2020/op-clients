//
//  CLLocationManager+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "JRSwizzle.h"
#import "PPEventDispatcher+Internal.h"
#import "PPEvent.h"
#import "NSObject+AutoSwizzle.h"

@interface CLLocationManager(Hook)

@end


@implementation CLLocationManager(Hook)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    }
}

HOOKEDInstanceMethod(void, startUpdatingLocation){
    __weak typeof(self) weakSelf = self;
    
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerStartLocationUpdates) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, startUpdatingLocation);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKEDInstanceMethod(void, requestAlwaysAuthorization) {
    
    __weak typeof(self) weakSelf = self;
    PPEventIdentifier identifier = PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestAlwaysAuthorization);
    
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution:identifier executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, requestAlwaysAuthorization);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}


HOOKEDInstanceMethod(void, requestWhenInUseAuthorization) {
    
    __weak typeof(self) weakSelf = self;
    [[PPEventDispatcher sharedInstance] fireEventWithMaxOneTimeExecution: PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestWhenInUseAuthorization) executionBlock:^{
        CALL_ORIGINAL_METHOD(weakSelf, requestWhenInUseAuthorization);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}


HOOKEDInstanceMethod(void, setDelegate:(id<CLLocationManagerDelegate>)delegate) {
    if (!delegate) {
        CALL_ORIGINAL_METHOD(self, setDelegate:(id<CLLocationManagerDelegate>)delegate);
        return;
    }
    
    NSMutableDictionary *evData = [@{} mutableCopy];
    __weak NSMutableDictionary *weakEvData = evData;
    
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock setDelegateConfirmation = ^{
        id possiblyModifiedDelegate = weakEvData[kPPLocationManagerDelegate];
        if (![possiblyModifiedDelegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
            return;
        }
        CALL_ORIGINAL_METHOD(weakSelf, setDelegate:possiblyModifiedDelegate);
    };
    
    [evData addEntriesFromDictionary:@{ kPPLocationManagerDelegate: delegate,
                                        kPPLocationManagerInstance: self,
                                        kPPLocationManagerSetDelegateConfirmation: setDelegateConfirmation
                                       }];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerSetDelegate) eventData:evData whenNoHandlerAvailable:setDelegateConfirmation];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
}

HOOKEDInstanceMethod(CLLocation*, location) {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    CLLocation *actualLocation = CALL_ORIGINAL_METHOD(self, location);
    if (actualLocation) {
        [evData setObject:actualLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    }
    
    [evData setObject:self forKey:kPPLocationManagerInstance];
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerGetCurrentLocation) eventData:evData whenNoHandlerAvailable:nil];
    
    [[PPEventDispatcher sharedInstance] fireEvent:event];
    
    CLLocation *possiblyModifiedLocation = evData[kPPLocationManagerGetCurrentLocationValue];
    
    if (!(possiblyModifiedLocation && [possiblyModifiedLocation isKindOfClass:[CLLocation class]])) {
        return nil;
    }
    
    return possiblyModifiedLocation;
}



@end
