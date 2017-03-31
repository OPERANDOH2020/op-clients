//
//  CloakNibView.m
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CloakNibView.h"
#import "NSBundle+RSFrameworkHooks.h"

@interface CloakNibView()
@property (readwrite, strong, nonatomic) UIView *contentView;
@end

@implementation CloakNibView

-(void)commonInit {
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle PPCloakBundle]];
    UIView *view = [nib instantiateWithOwner:self options:nil].firstObject;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:view];
    self.contentView = view;
    
    NSLayoutConstraint*(^buildConstraintWithSelfForAttribute)(NSLayoutAttribute attribute) = ^NSLayoutConstraint*(NSLayoutAttribute attribute){
        return [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:1.0 constant:0];
    };
    
    [self addConstraints:@[buildConstraintWithSelfForAttribute(NSLayoutAttributeTop),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeBottom),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeLeft),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeRight)]];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end
