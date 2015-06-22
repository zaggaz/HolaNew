//
//  JViewController.h
//  Hola
//
//  Created by Jin Wang on 30/3/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JViewController : UIViewController<CLLocationManagerDelegate>
{
    JASidePanelController       *mJASidePanel;
    IBOutlet UIButton *mBtnLogin;
    IBOutlet UIButton *mBtnFacebookLogin;
    IBOutlet UIButton *mBtnEmailLogin;

    IBOutlet UIView *mViewEmailLoginContainer;
    IBOutlet UIView *mViewEmailLoginMainContainer;
    IBOutlet UITextField *mTxtEmail;
    IBOutlet UITextField *mTxtPassword;
    IBOutlet UIButton *mBtnCreateAccount;
    
    IBOutlet UIView *mViewEmailSignupContainer;
    IBOutlet UIView *mViewEmailSignupMainContainer;
    IBOutlet UITextField *mTxtSignupEmail;
    IBOutlet UITextField *mTxtSignupPassword;
    IBOutlet UITextField *mTxtSignupConfirmPassword;
    IBOutlet UITextField *mTxtSignupFirstName;
    IBOutlet UITextField *mTxtSignupLastName;
    
    float latitude;
    float longitude;
    
    IBOutlet UIView *mViewMaskBackground;
}
+ ( JViewController* ) sharedController;
@property(nonatomic, strong)    CLLocationManager *locationManager;
@end
