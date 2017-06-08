//
//  NSBundle+TestSwizzle.m
//  Operando
//
//  Created by Costin Andronache on 6/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

#import "NSBundle+TestSwizzle.h"

@implementation NSBundle(TestSwizzle)

+(void)load {
    NSLog(@"\n OVERRIDING FROM PPCLOAK \n");
}

@end
