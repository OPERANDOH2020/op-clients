//
//  UIView+FullConstrain.m
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonViewUtils.h"

@implementation CommonViewUtils

+(void)fullyConstrainView:(UIView*)view inHostView:(UIView*)hostView {
    view.translatesAutoresizingMaskIntoConstraints = false;
    [hostView addSubview:view];
    
    NSLayoutConstraint*(^buildConstraintWithSelfForAttribute)(NSLayoutAttribute attribute) = ^NSLayoutConstraint*(NSLayoutAttribute attribute){
        return [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:hostView attribute:attribute multiplier:1.0 constant:0];
    };
    
    [hostView addConstraints:@[buildConstraintWithSelfForAttribute(NSLayoutAttributeTop),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeBottom),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeLeft),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeRight)]];
}

@end
