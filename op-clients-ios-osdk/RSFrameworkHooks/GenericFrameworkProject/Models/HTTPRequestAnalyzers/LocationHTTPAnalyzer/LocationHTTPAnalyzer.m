//
//  LocationHTTPAnalyzer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationHTTPAnalyzer.h"
#import "Common.h"

@interface NSURLRequest(AnalyzingUtilities)
-(NSString*)contentType;
@end

@implementation NSURLRequest(AnalyzingUtilities)

-(NSString *)contentType {
    NSString *contentTypeHeader = @"Content-Type";
    NSString *value = [self valueForHTTPHeaderField:contentTypeHeader];
    if (!value) {
        value = [self valueForHTTPHeaderField:[contentTypeHeader lowercaseString]];
    }
    return value;
}

@end

@interface LocationHTTPAnalyzer()
@property (strong, nonatomic) id<HTTPBodyParser> httpBodyParser;
@end

@implementation LocationHTTPAnalyzer

-(instancetype)initWithHttpBodyParser:(id<HTTPBodyParser>)parser {
    if (self = [super init]) {
        self.httpBodyParser = parser;
    }
    return self;
}

-(void)checkIfAnyLocationFrom:(NSArray<CLLocation *> *)locations isSentInRequest:(NSURLRequest *)request withCompletion:(void (^)(BOOL))completion {
    SAFECALL(completion, NO);
}


-(NSDictionary*)dictionaryFromBodyIfPossible:(NSURLRequest*)request {
    NSDictionary *result = nil;
    NSString *contentType = request.contentType.lowercaseString;
    if ([contentType containsString:@"json"]) {
        result = [self.httpBodyParser parseJSONFromBodyData:request.HTTPBody];
    }
    else if([contentType containsString:@"x-www-form-urlencoded"]){
        result = [self.httpBodyParser parseFormURLEncodedFromBodyData:request.HTTPBody];
    } else {
        result = nil; //must check for multipart data also
    }
    
    return result;
}



@end
