//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont fontWithName:@"Gesta-Regular" size:17.0f]
//#define HUD_STATUS_COLOR		[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define HUD_STATUS_COLOR		[UIColor whiteColor]

//define HUD_SPINNER_COLOR		[UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0]
#define HUD_SPINNER_COLOR		[UIColor colorWithRed:44.0/255.0 green:99.0/255.0 blue:210.0/255.0 alpha:1.0]
#define HUD_Error_COLOR	        [UIColor colorWithRed:221.0/255.0 green:68.0/255.0 blue:24.0/255.0 alpha:1.0]

#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0.0 alpha:0.6]
#define HUD_WINDOW_COLOR		[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]

#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"graphic_fax-sent_"]
#define HUD_IMAGE_ERROR			[[UIImage imageNamed:@"icon_status_expired_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProgressHUD : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (ProgressHUD *)shared;

+ (void)dismiss;

+ (void)show:(NSString *)status;
+ (void)show:(NSString *)status Interaction:(BOOL)Interaction;

+ (void)showSuccess:(NSString *)status;
+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction;

+ (void)showError:(NSString *)status;
+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction;

@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *background;
@property (nonatomic, retain) UIVisualEffectView *hud;
@property (nonatomic, retain) UIImageView *spinner;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label;

@end
