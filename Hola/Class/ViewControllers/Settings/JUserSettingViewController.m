//
//  JUserSettingViewController.m
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JUserSettingViewController.h"

@interface JUserSettingViewController ()

@end

@implementation JUserSettingViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
+ ( JUserSettingViewController* ) sharedController
{
    __strong static JUserSettingViewController* sharedController = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JUserSettingViewController alloc ] initWithNibName : @"JUserSettingViewController" bundle : nil ] ;
    } ) ;
    return sharedController ;
}
- (void)viewDidLoad {
    
    [mSegLookingFor setFrame:CGRectMake(mSegLookingFor.frame.origin.x, mSegLookingFor.frame.origin.y, mSegLookingFor.frame.size.width, 25)];
    
    mSwitchPush = [[SevenSwitch alloc]init];
    mSwitchPush.frame = CGRectMake(0, 0, 44, 20);
    mSwitchPush.center = CGPointMake(mViewPushContentContainer.frame.size.width / 2, mViewPushContentContainer.frame.size.height/2);
    [mSwitchPush addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [mSwitchPush setOnImage:[UIImage imageNamed:@"btn-toggle-on-bg@2x.png"]];
    [mSwitchPush setOffImage:[UIImage imageNamed:@"btn-toggle-off-bg@2x.png"]];
    mSwitchPush.isRounded = YES;
    mSwitchPush.shadowColor = [UIColor clearColor];
    [mSwitchPush setOn:YES];
    mSwitchPush.borderColor = [UIColor clearColor];
    mSwitchPush.inactiveColor = [UIColor clearColor];
    mSwitchPush.onTintColor = [UIColor clearColor];
    [mViewPushContentContainer addSubview:mSwitchPush];
    
    
    mSwitchVisibility = [[SevenSwitch alloc]init];
    mSwitchVisibility.frame = CGRectMake(0, 0, 44, 20);
    mSwitchVisibility.center = CGPointMake(mViewPushContentContainer.frame.size.width / 2, mViewPushContentContainer.frame.size.height/2);
    [mSwitchVisibility addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [mSwitchVisibility setOnImage:[UIImage imageNamed:@"btn-toggle-on-bg@2x.png"]];
    [mSwitchVisibility setOffImage:[UIImage imageNamed:@"btn-toggle-off-bg@2x.png"]];
    mSwitchVisibility.isRounded = YES;
    mSwitchVisibility.shadowColor = [UIColor clearColor];
    [mSwitchVisibility setOn:YES];
    mSwitchVisibility.borderColor = [UIColor clearColor];
    mSwitchVisibility.inactiveColor = [UIColor clearColor];
    mSwitchVisibility.onTintColor = [UIColor clearColor];
    [mViewVisibilityContentContainer addSubview:mSwitchVisibility];
    
    
    
    //distance slider
//    UIImage* sliderCenterImage = [UIImage imageNamed:@"sliderbtn.PNG"];
//    [mSliderDistance setThumbImage:sliderCenterImage forState:UIControlStateNormal];
//    
//    UIImage *leftStretch2 = [[UIImage imageNamed:@"slider_right.png"]
//                             stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
//    [mSliderDistance setMinimumTrackImage:leftStretch2 forState:UIControlStateNormal];
//    
//    UIImage *rightStretch2 = [[UIImage imageNamed:@"slider_left.png"]
//                              stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
//    [mSliderDistance setMaximumTrackImage:rightStretch2 forState:UIControlStateNormal];
    

    
    [mSliderDistance setMinimumValue:SETTING_MIN_DISTANCE];
    [mSliderDistance setMaximumValue:SETTING_MAX_DISTANCE];
    mSliderDistance.value = SETTING_MAX_DISTANCE / 2;
    
    mSliderAgeRange.maximumValue = SETTING_MAX_AGE;
    mSliderAgeRange.minimumValue = SETTING_MIN_AGE;
    mSliderAgeRange.upperValue = SETTING_MAX_AGE;
    mSliderAgeRange.lowerValue = SETTING_MIN_AGE;
    
    
    [mSliderAgeRange addTarget:self
                        action:@selector(slideRangeValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    
    //age slider

    
    
    [mScrollMainContainer setContentSize:CGSizeMake(mViewMainContainer.frame.size.width, mViewMainContainer.frame.size.height + 20)];
    
    [super viewDidLoad];
    [self loadSettings];
    
    
    [mBtnDeleteAccount.layer setCornerRadius:3.0f];
    [mBtnWeChatShare.layer setCornerRadius:3.0f];
    [mBtnLogout.layer setCornerRadius:3.0f];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([Engine gUserSetting] && [Engine gUserSetting].mUserId.length > 0)
    {
        if(![[Engine gUserSetting].mUserId isEqual:[Engine gPersonInfo].mUserId])
            [self loadSettings];
        else
            [self fillSettingValue];
    }
    
//    
//    [self fillSettingValue];
//    [self slideRangeValueChanged:nil];
    [super viewWillAppear:animated];
}
#pragma mark load settings
-(void)loadSettings
{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:@"users" forKey:@"type"];
    [parameters setObject:@"get_user_setting" forKey:@"cmd"];
    
    //[SVProgressHUD showWithStatus:MSG_WAIT maskType:SVProgressHUDMaskTypeGradient];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            if([error1 isEqualToString:@"1"])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SVProgressHUD dismiss];
                if([[data objectForKey:@"error"] isEqualToString:@"0"])
                {
                    [[Engine gUserSetting] setDataWithDictionary:[data objectForKey:@"result"]];
                    [self fillSettingValue];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        
    }];

}
//age range change
-(void)fillSettingValue
{
    mSegLookingFor.selectedSegmentIndex = [Engine gUserSetting].mLookingGender;
    [mSwitchPush setOn:[Engine gUserSetting].mPushNotification];
    [mSwitchVisibility setOn:[Engine gUserSetting].mVisibility];
    [mSliderAgeRange setLowerValue:[Engine gUserSetting].mMinAge];
    [mSliderAgeRange setUpperValue:[Engine gUserSetting].mMaxAge];
    mSliderDistance.value = (int)[Engine gUserSetting].mMaxDistance;
    
    
    mLblAgeRangeValue.text = [NSString stringWithFormat:@"%d ~ %d", (int)mSliderAgeRange.lowerValue, (int)mSliderAgeRange.upperValue];
    mLblDistanceValue.text = [NSString stringWithFormat:@"%d(km)", (int)mSliderDistance.value];
}
-(IBAction)onSlideValueChange:(id)sender
{
    mLblDistanceValue.text = [NSString stringWithFormat:@"%d(km)", (int)mSliderDistance.value];
    
}
//push notification and visibility
-(IBAction)switchChanged:(id)sender
{
    SevenSwitch *pCurSwitch = (SevenSwitch *)sender;
}
//distance change
- (void)slideRangeValueChanged:(id)control
{
    CERangeSlider* slider = (CERangeSlider*)control;
    if([slider isEqual: mSliderAgeRange])
    {
        if(mSliderAgeRange.upperValue <SETTING_MIN_AGE + 1)
            mSliderAgeRange.upperValue = SETTING_MIN_AGE + 1;
        mLblAgeRangeValue.text = [NSString stringWithFormat:@"%d ~ %d", (int)mSliderAgeRange.lowerValue, (int)mSliderAgeRange.upperValue];
    }
}

-(IBAction)onTouchBtnLeftMenu:(id)sender
{
    [self saveUserSetting];
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
}
-(IBAction)onTouchBtnRightMenu:(id)sender
{
    [self saveUserSetting];
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_RIGHTBTN_TOUCH object: nil];
}
-(IBAction)onTouchBtnLogout:(id)sender
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
    
}
-(void)saveUserSetting
{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [Engine setBUserSettingChanged:YES];
    
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSegLookingFor.selectedSegmentIndex] forKey:@"looking_gender"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSwitchPush.isOn] forKey:@"push_notification"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSwitchVisibility.isOn] forKey:@"visibility"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSliderDistance.value] forKey:@"max_distance"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSliderAgeRange.lowerValue] forKey:@"min_age"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)mSliderAgeRange.upperValue] forKey:@"max_age"];
    
    [parameters setObject:@"users" forKey:@"type"];
    [parameters setObject:@"save_user_setting" forKey:@"cmd"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            else
            {

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if([[data objectForKey:@"error"] isEqualToString:@"0"])
                {
                    [[Engine gUserSetting] setDataWithDictionary:[data objectForKey:@"result"]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_CHANGED object:nil];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                    return ;
                }
                
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
    }];
    
}
-(IBAction)onTouchBtnDeleteAccount:(id)sender
{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [Engine setBUserSettingChanged:YES];
    
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];

    
    [parameters setObject:@"users" forKey:@"type"];
    [parameters setObject:@"delete_account" forKey:@"cmd"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
       // NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            else
            {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if([[data objectForKey:@"error"] isEqualToString:@"0"])
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_CHANGED object:nil];
                    [self onTouchBtnLogout:nil];
                }
                else
                {                    
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                    return ;
                }
                
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
    }];
}

@end
