//
//  LocationHTTPAnalyzer.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol HTTPBodyParser <NSObject>

-(NSDictionary* _Nullable)parseJSONFromBodyData:(NSData* _Nonnull)bodyData;
-(NSDictionary* _Nullable)parseFormURLEncodedFromBodyData:(NSData* _Nonnull)bodyData;
-(NSDictionary* _Nullable)parseMultipartBodyData:(NSData* _Nonnull)data withBoundary:(NSString* _Nonnull)boundary;

@end

@interface LocationHTTPAnalyzer : NSObject

-(instancetype _Nonnull)initWithHttpBodyParser:(id<HTTPBodyParser> _Nonnull)parser;

-(void)checkIfAnyLocationFrom:(NSArray<CLLocation*>* _Nonnull)locations isSentInRequest:(NSURLRequest* _Nonnull)request withCompletion:(void(^ _Nullable)(BOOL yesOrNo))completion;

@end
