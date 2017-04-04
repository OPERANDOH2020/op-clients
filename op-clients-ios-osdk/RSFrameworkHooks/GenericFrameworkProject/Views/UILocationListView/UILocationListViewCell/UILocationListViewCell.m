//
//  UILocationListViewCell.m
//  PPCloak
//
//  Created by Costin Andronache on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationListViewCell.h"
#import "UILocationIndexPinView.h"
#import "Common.h"

@implementation UILocationListViewCellCallbacks
@end

@interface UILocationListViewCell() <UITextFieldDelegate, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTF;
@property (strong, nonatomic) UILocationListViewCellCallbacks *callbacks;
@property (weak, nonatomic) IBOutlet UILocationIndexPinView *locationIndexPinView;

@end

@implementation UILocationListViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.longitudeTF.delegate = self;
    self.latitudeTF.delegate = self;
    self.delegate = self;
}

+(NSString *)identifierNibName {
    return @"UILocationListViewCell";
}

-(void)setupWithLatitude:(double)latitude longitude:(double)longitude index:(NSInteger)index callbacks:(UILocationListViewCellCallbacks*)callbacks {
    [self setTextFieldsWithLatitude:latitude longitude:longitude];
    self.callbacks = callbacks;
    self.locationIndexPinView.index = index;
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
    NSLog(@"text field did end editing");
    NSLog(@"self. callbacks :%@", self.callbacks);
}

-(void)updateTextFieldsAndCall {
    double latitude = [self.latitudeTF.text doubleValue];
    double longitude = [self.longitudeTF.text doubleValue];
    [self setTextFieldsWithLatitude:latitude longitude:longitude];
    SAFECALL(self.callbacks.onCoordinatesUpdate, latitude, longitude)
}

#pragma mark - 


-(NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    
    expansionSettings.fillOnTrigger = YES;
    expansionSettings.threshold = 3.4;
    expansionSettings.buttonIndex = 0;
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.enableSwipeBounces = YES;
    
    WEAKSELF
    
    if (direction == MGSwipeDirectionLeftToRight) {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            SAFECALL(weakSelf.callbacks.onDelete)
            return YES;
        }];
        return @[button];
    }
    
    return @[];
}

@end
