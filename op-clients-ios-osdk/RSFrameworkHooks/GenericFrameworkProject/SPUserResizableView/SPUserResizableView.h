//
//  SPUserResizableView.h
//  SPUserResizableView
//
//  Created by Stephen Poletto on 12/10/11.
//
//  SPUserResizableView is a user-resizable, user-repositionable
//  UIView subclass.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct SPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} SPUserResizableViewAnchorPoint;

@protocol SPUserResizableViewDelegate;
@class SPGripViewBorderView;

@interface SPUserResizableView : UIView {
    SPGripViewBorderView *borderView;
    __unsafe_unretained UIView *contentView;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    SPUserResizableViewAnchorPoint anchorPoint;
    
    __unsafe_unretained id <SPUserResizableViewDelegate> delegate;
}

@property (nonatomic, assign) id <SPUserResizableViewDelegate> delegate;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (assign, nonatomic) BOOL preventsPositionOutsideSuperview;
@property (assign, nonatomic) BOOL disableResizing;
@property (assign, nonatomic) BOOL keepEditingHandlesHidden;


- (void)hideEditingHandles;
- (void)showEditingHandles;

@property (strong, nonatomic) void (^ _Nullable onTapCallback)();

@end

@protocol SPUserResizableViewDelegate <NSObject>

@optional
// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView;

@optional
// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView;

@optional
-(void)userResizableViewDidChangeFrame:(SPUserResizableView*)userResizableView;

@optional
-(void)userResizableViewDidReceiveLongPress:(SPUserResizableView*)userResizableView;


@optional
-(void)userResizableViewDidReceiveTap:(SPUserResizableView*)userResizableView;

@optional
-(void)userResizableViewDidReceiveDoubleTap:(SPUserResizableView*)userResizableView;

@end
