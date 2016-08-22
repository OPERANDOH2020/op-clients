//
//  NSDictionary+CookieHijacked.m
//  Operando
//
//  Created by Costin Andronache on 8/22/16.
//  Copyright © 2016 Operando. All rights reserved.
//

#import "NSDictionary+CookieHijacked.h"
#import "JRSwizzle.h"

@interface NSURLRequest(HijackURL)
-(id)operando_initWithURL:(NSURL *)URL;
@end

@implementation NSURLRequest(HijackURL)

-(id)operando_initWithURL:(NSURL *)URL
{
    NSLog(@"url to %@", URL);
    return [self operando_initWithURL:URL];
}


+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        BOOL result = [[self class] jr_swizzleMethod:@selector(initWithURL:) withMethod:@selector(operando_initWithURL:) error:&error];
        if (!result || error) {
            NSLog(@"Can't swizzle methods - %@", [error description]);
        }
    });
}

@end


@interface NSURLSessionDataTask(HijackResume)
-(void)operando_resume;
@end

@implementation NSURLSessionDataTask(HijackResume)

-(void)operando_resume
{
    NSLog(@"data task \ncurrent request: %@\n original request: %@", self.currentRequest, self.originalRequest);
    [self operando_resume];
}

@end