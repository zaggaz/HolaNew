//
//  JUserSettingViewController.h
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "CERangeSlider.h"
#import "NMRangeSlider.h"

@interface JUserSettingViewController : UIViewController
{
    IBOutlet UISegmentedControl *mSegLookingFor;
    IBOutlet UIView *mViewPushContentContainer;
    IBOutlet UIView *mViewVisibilityContentContainer;
    
    IBOutlet UIView *mViewAgeRangeContainer;
    IBOutlet UILabel *mLblAgeRangeValue;
    
    IBOutlet UISlider *mSliderDistance;
    IBOutlet UILabel *mLblDistanceValue;
    
    IBOutlet UIScrollView *mScrollMainContainer;
    IBOutlet UIView *mViewMainContainer;
    
    SevenSwitch *mSwitchPush;
    SevenSwitch *mSwitchVisibility;

    
    IBOutlet NMRangeSlider *mSliderAgeRange;

    IBOutlet UIButton *mBtnLogout;
    IBOutlet UIButton *mBtnDeleteAccount;
    IBOutlet UIButton *mBtnWeChatShare;
}
+ ( JUserSettingViewController* ) sharedController;

@end
