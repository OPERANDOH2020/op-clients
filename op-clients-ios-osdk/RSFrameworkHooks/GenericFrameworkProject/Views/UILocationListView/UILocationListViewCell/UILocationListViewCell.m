//
//  UILocationListViewCell.m
//  PPCloak
//
//  Created by Costin Andronache on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationListViewCell.h"
#import "Common.h"

@interface UILocationListViewCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTF;
@property (strong, nonatomic) UILocationListCellUpdateCallback callback;

@end

@implementation UILocationListViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.longitudeTF.delegate = self;
    self.latitudeTF.delegate = self;
    
}

+(NSString *)identifierNibName {
    return @"UILocationListViewCell";
}

-(void)setupWithLatitude:(double)latitude longitude:(double)longitude callbackOnUpdate:(UILocationListCellUpdateCallback)callback {
    [self setTextFieldsWithLatitude:latitude longitude:longitude];
    self.callback = callback;
}

-(void)setTextFieldsWithLatitude:(double)latitude longitude:(double)longitude {
    self.latitudeTF.text = [NSString stringWithFormat:@"%.4f", latitude];
    self.longitudeTF.text = [NSString stringWithFormat:@"%.4f", longitude];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (textField == self.latitudeTF) {
            [self.longitudeTF becomeFirstResponder];
        } else {
            [textField endEditing:YES];
        }
        
        [self updateTextFieldsAndCall];
    });
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateTextFieldsAndCall];
}

-(void)updateTextFieldsAndCall {
    double latitude = [self.latitudeTF.text doubleValue];
    double longitude = [self.longitudeTF.text doubleValue];
    [self setTextFieldsWithLatitude:latitude longitude:longitude];
    SAFECALL(self.callback, latitude, longitude)
}

@end
