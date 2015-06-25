//
//  JViewController.m
//  Hola
//
//  Created by Jin Wang on 30/3/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JViewController.h"
#import "JProfileViewController.h"
#import "JHomeViewController.h"
#import "JHomeLeftViewController.h"
#import "JHomeRightViewController.h"
#import "JFriendListViewController.h"
#import "JMatchViewController.h"
#import "JChatViewController.h"
#import "JUserSettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

#import "JSearchViewController.h"
#import "JMessgeHistoryViewController.h"
#import "DataService.h"

#import <Parse/Parse.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface JViewController ()

@end

@implementation JViewController
@synthesize locationManager;

// TODO: This is unnecessary once all http requests use the dataservice as it handles invalid tokens.
- (void)checkAccessToken {
    DataService *dataService = [DataService sharedDataService];
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];

    [parameters setObject:@"checkToken" forKey:@"type"];
    [parameters setObject:@"checkToken" forKey:@"cmd"];
    [dataService postWithParameters:parameters successHandler:^(NSObject *result) {
    } currentView:self.view];
};
- (void)viewDidLoad {
    [super viewDidLoad];
    
    mJASidePanel = [[JASidePanelController alloc] init];
    mJASidePanel.shouldDelegateAutorotateToVisiblePanel = NO;
    mJASidePanel.navigationController.navigationBarHidden = TRUE;
    JHomeLeftViewController *homeLeftView = [JHomeLeftViewController sharedController];
    mJASidePanel.leftPanel = homeLeftView;
    
    JHomeRightViewController *homeRightView = [JHomeRightViewController sharedController];
    mJASidePanel.rightPanel = homeRightView;

    JHomeViewController *homeView = [JHomeViewController sharedController];
    mJASidePanel.centerPanel = homeView;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onActionShowHome:) name: SHOW_MAIN_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onActionShowMainHome:) name: SHOW_MAIN_HOME object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onCloseSideView:) name: CLOSE_SIDE_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onActionChatView:) name: SHOW_CHAT_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onActionMatchView:) name: SHOW_MATCH_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onShowProfileView:) name: SHOW_PROFILE object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onShowFriendListView:) name: SHOW_FRIEND_LIST_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onShowSettingView:) name: SHOW_SETTING_VIEW object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onShowLocationView:) name: SHOW_LOCATION object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onLogout:) name: NOTIFICATION_LOGOUT object: nil];
    
    [mBtnLogin.layer setCornerRadius:3.0f];
    [mBtnLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnLogin.layer setBorderWidth:1.0f];
    
    [mBtnSignUp.layer setCornerRadius:3.0f];
    [mBtnSignUp.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnSignUp.layer setBorderWidth:1.0f];
    
    [mBtnCreateAccount.layer setCornerRadius:3.0f];
    [mBtnCreateAccount.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnCreateAccount.layer setBorderWidth:1.0f];
    
    [mBtnFacebookLogin.layer setCornerRadius:3.0f];
    [mBtnFacebookLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnFacebookLogin.layer setBorderWidth:1.0f];
    
    [mBtnEmailLogin.layer setCornerRadius:3.0f];
    [mBtnEmailLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnEmailLogin.layer setBorderWidth:1.0f];
    
    if([CLLocationManager locationServicesEnabled])
    {
        
        locationManager = [[CLLocationManager alloc] init];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    
    [mViewEmailLoginContainer setFrame:CGRectMake(0, 100, mViewEmailLoginContainer.frame.size.width, mViewEmailLoginContainer.frame.size.height)];
    [mViewEmailLoginMainContainer.layer setCornerRadius:10];
    [mViewEmailLoginMainContainer.layer setMasksToBounds:YES];
    [self.view addSubview:mViewEmailLoginContainer];
    [mViewEmailLoginContainer setAlpha:0];
    

    [mViewEmailSignupContainer setFrame:CGRectMake(0, SCREEN_HEIGHT, mViewEmailSignupContainer.frame.size.width, mViewEmailSignupContainer.frame.size.height)];
    [mViewEmailSignupMainContainer.layer setCornerRadius:10];
    [mViewEmailSignupMainContainer.layer setMasksToBounds:YES];
    [self.view addSubview:mViewEmailSignupContainer];

    
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:mBtnCreateAccount.titleLabel.text];
    [mBtnCreateAccount setAttributedTitle:attributeString forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ ( JViewController* ) sharedController
{
    __strong static JViewController* sharedController = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JViewController alloc ] initWithNibName : @"JViewController" bundle : nil ] ;
    } ) ;
    
    return sharedController ;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict=[defaults dictionaryForKey:@"current_user"];
    
    NSDictionary *dictLogin = [defaults dictionaryForKey:@"login_info"];
    if(dictLogin)
    {
        mTxtEmail.text = [dictLogin objectForKey:@"email"];
        mTxtPassword.text = [dictLogin objectForKey:@"password"];
    }
    if(dict)
    {
        if([Engine isBackAction] == YES)
        {
            [Engine setIsBackAction:NO];
            
        }
        else
        {
            NSString *currentLoginStep = [defaults objectForKey:@"current_user_step"];
            
            if([currentLoginStep isEqualToString : @"new"] || [currentLoginStep isEqualToString : @"profile"])
            {
                [[Engine gPersonInfo] setDataWithDictionary:dict];
                [[Engine gPersonInfo] setCurrentUserStep:currentLoginStep];
                [self checkAccessToken];
                [self onActionShowHome:nil];
            }
        }
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [self.view endEditing:YES];
}
#pragma mark location manager
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    CLLocation *pLocation = [locations objectAtIndex:0];
    latitude = pLocation.coordinate.latitude;
    longitude = pLocation.coordinate.longitude;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error with %@",error);
}

-(IBAction)onTouchBtnLogin:(id)sender
{
    JProfileViewController *pView = [JProfileViewController sharedController];
    [pView setMPageType:@"introduction"];
    [self.navigationController pushViewController:pView animated:YES];
    
}

#pragma mark notifications
-(void)onActionShowHome :(id)sender
{
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated: NO];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict=[defaults dictionaryForKey:@"current_user"];
    if(dict)
    {
        NSString *currentLoginStep = [defaults objectForKey:@"current_user_step"];
        if([currentLoginStep isEqualToString : @"new"])
        {
            [[Engine gPersonInfo] setDataWithDictionary:dict];
            JProfileViewController * proView = [JProfileViewController sharedController];
            [UIView animateWithDuration:0.75
                             animations:^{
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                 //[Engine setIsBackAction:FALSE];
                                 [self.navigationController pushViewController:proView animated:NO];
                                 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                             }];
            
        }
        else if([currentLoginStep isEqualToString : @"profile"])
        {
            [[Engine gPersonInfo] setDataWithDictionary:dict];
            //JQuestionsViewController * qView = [JQuestionsViewController sharedController];
            //JMainTabBC * tabView = [JMainTabBC sharedController];
            [UIView animateWithDuration:0.75
                             animations:^{
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                 //[Engine setIsBackAction:FALSE];
                                 [self.navigationController pushViewController:mJASidePanel animated:NO];
                                 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                             }];
              [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_MAIN_HOME object:nil];
            
        }
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject: [Engine gPersonInfo].mUserId forKey: @"owner"];
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Succeed: %d   Error: %@",succeeded, error);
        }];
        return;
    }
}
- (void)onCloseSideView: (NSNotification *)notification
{
    [mJASidePanel showCenterPanelAnimated:NO];
    if(notification.object)
    {
        UIViewController* viewController=(UIViewController*)notification.object;
        [mJASidePanel.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)onActionShowMainHome:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JHomeViewController *pView = [JHomeViewController sharedController];
    mJASidePanel.centerPanel = pView;
 //   [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_CHANGED object:nil];
 //   [Engine setBUserSettingChanged:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_CHANGED object:nil];
    
}
-(void)onShowFriendListView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JFriendListViewController *pView = [JFriendListViewController sharedController];
    mJASidePanel.centerPanel = pView;

}
-(void)onActionMatchView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JMatchViewController *pView = [JMatchViewController sharedController];
    mJASidePanel.centerPanel = pView;
    
}
-(void)onActionChatView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JChatViewController *pView = [JChatViewController sharedController];
    mJASidePanel.centerPanel = pView;
}
-(void)onShowSettingView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JUserSettingViewController *pView = [JUserSettingViewController sharedController];
    mJASidePanel.centerPanel = pView;
}
-(void)onShowProfileView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JProfileViewController *pView = [JProfileViewController sharedController];
    [pView setMPageType:@"setting"];
    
    mJASidePanel.centerPanel = pView;
}
-(void)onShowLocationView:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    JSearchViewController *pView = [JSearchViewController sharedController];    
    mJASidePanel.centerPanel = pView;
}
-(void)onLogout:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_SIDE_VIEW object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"current_user"]) {
        [defaults removeObjectForKey:@"current_user"];
        [defaults synchronize];
    }
    [AppEngine clearInstance];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSArray *messages=[context executeFetchRequest:fetch error:nil];
    for (id message in messages) {
        [context deleteObject:message];
    }

    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                         //[self.tabbar.navigationController popToRootViewControllerAnimated:YES];
                     }];
    [FBSession.activeSession closeAndClearTokenInformation];
    
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
}

#pragma mark email login
-(IBAction)onTouchBtnEmailLogin:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view insertSubview:mViewMaskBackground belowSubview:mViewEmailLoginContainer];
        [mViewEmailLoginContainer setAlpha:1];
        
    } completion:^(BOOL finished){
        
    }];
}
-(IBAction)onTouchBtnHideEmailLogin:(id)sender
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [mViewEmailLoginContainer setAlpha:0];
        
    } completion:^(BOOL finished){
        [mViewMaskBackground removeFromSuperview];
    }];
}
-(IBAction)onTouchBtnDoEmailLogin:(id)sender
{
    if(mTxtEmail.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_EMAIL_SHOULD_NOT_EMPTY];
        
        return;
    }
    if(![AppEngine validEmail: mTxtEmail.text])
    {
        [SVProgressHUD showErrorWithStatus:MSG_REGISTER_EMAIL_ADDRESS_NOT_VALID];
        return;
    }
    if(mTxtPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_PASSWORD_SHOULD_NOT_EMPTY];
        return;
    }
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];

    [parameters setObject:mTxtEmail.text forKey:@"email"];
    [parameters setObject:mTxtPassword.text forKey:@"password"];

    
    [parameters setObject:@"login_signup" forKey:@"type"];
    [parameters setObject:@"direct_login" forKey:@"cmd"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];

                if([error1 isEqualToString:@"0"])
                {
                    [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"result"]];
                    
                    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                   
                        [mTxtEmail setText:@""];
                        [mTxtPassword setText:@""];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                        [defaults setObject:nil forKey:@"login_info"];
                        [defaults synchronize];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_CHANGED object:nil];
                    [self onTouchBtnHideEmailLogin:nil];
                    [self onActionShowHome:nil];
                }
                else if([error1 isEqualToString:@"1"])
                {
                    [SVProgressHUD showErrorWithStatus:MSG_LOGIN_EMAIL_PASSWORD_NOT_MATCH];
                    return ;
                }
                else if([error1 isEqualToString:@"2"])
                {
                    [SVProgressHUD showErrorWithStatus:MSG_ACTIVATE_ACCOUNT];
                    return ;
                }
            
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        NSLog(@"%@",[NSString stringWithFormat:@"%@", error]);
        
    }];
}
#pragma mark login;

-(IBAction)onTouchBtnHideEmailSignup:(id)sender
{
    [self.view endEditing:YES];
    mTxtSignupEmail.text = @"";
    mTxtSignupFirstName.text = @"";
    mTxtSignupLastName.text = @"";
    mTxtSignupPassword.text = @"";
    mTxtSignupConfirmPassword.text = @"";
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mViewEmailSignupContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        mTxtSignupConfirmPassword.text = @"";
        mTxtSignupEmail.text = @"";
        mTxtSignupPassword.text = @"";
        [mViewMaskBackground removeFromSuperview];
    }];
}
-(IBAction)onTouchBtnCreateEmailLogin:(id)sender
{

    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [mViewEmailLoginContainer setAlpha:0];
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
             mViewEmailSignupContainer.transform = CGAffineTransformMakeTranslation(0,-(SCREEN_HEIGHT - 20));
        } completion:nil];

    }];
    
//    JProfileViewController *mViewProfile = [JProfileViewController sharedController];
//    [self.navigationController pushViewController:mViewProfile animated:YES];
}
-(void) keyboardWillShow:(NSNotification *)note{
    
    NSDictionary *info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}
-(void) keyboardWillHide:(NSNotification *)note
{
    
}
-(IBAction)onTouchBtnCreateAccount:(id)sender
{
    if(mTxtSignupEmail.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_EMAIL_SHOULD_NOT_EMPTY];
        
        return;
    }
    if(![AppEngine validEmail: mTxtSignupEmail.text])
    {
        [SVProgressHUD showErrorWithStatus:MSG_REGISTER_EMAIL_ADDRESS_NOT_VALID];
        return;
    }
    if(mTxtSignupPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_PASSWORD_SHOULD_NOT_EMPTY];
        return;
    }
    if(mTxtSignupConfirmPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_CONFIRM_PASSWORD_SHOULD_NOT_EMPTY];
        return;
    }
    if(![mTxtSignupPassword.text isEqualToString:mTxtSignupConfirmPassword.text])
    {
        [SVProgressHUD showErrorWithStatus:MSG_PASSWORD_CONFIRM_NOT_MATCH];
        return;
    }
    if(mTxtSignupFirstName.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_FIRSTNAME_SHOULD_NOT_EMPTY];
        return;
    }
    if(mTxtSignupLastName.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:MSG_LASTNAME_SHOULD_NOT_EMPTY];
        return;
    }
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"lat"];
    [parameters setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"lgn"];
    [parameters setObject:mTxtSignupEmail.text forKey:@"email"];
    [parameters setObject:mTxtSignupPassword.text forKey:@"password"];
    [parameters setObject:mTxtSignupFirstName.text forKey:@"firstname"];
    [parameters setObject:mTxtSignupLastName.text forKey:@"lastname"];
    
    [parameters setObject:@"login_signup" forKey:@"type"];
    [parameters setObject:@"register" forKey:@"cmd"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DataService *dataService = [DataService sharedDataService];
    [dataService postWithParameters:parameters successHandler:^(NSArray* pUserArr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"You are successfully registered! The verification mail has been sent." ];
        [self onTouchBtnHideEmailSignup:nil];
//        [[Engine gPersonInfo] setDataWithDictionary:pUserArr];
//      [self onActionShowHome:nil];
    } currentView:self.view];
}

#pragma mark facebook login
-(IBAction)onTouchBtnFB:(id)sender
{
#if 0//test
    NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
    [json setObject:@"jin.wang@gmail.com" forKey:@"email"];
    [json setObject:@"Jin" forKey:@"first_name"];
    [json setObject:@"Wang" forKey:@"last_name"];
    [json setObject:@"343" forKey:@"id"];
    [self doProcessFBLogin:json login_type:@"facebook"];
    //[self setLoginWithEmail:json login_type:@"facebook"];
#else
    [self openFacebookAuthentication];
    return;
#endif
}
-(void)openFacebookAuthentication
{
    NSArray *permission = [NSArray arrayWithObjects:@"public_profile", @"user_birthday",
                           @"email", nil];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [self facebookLoaded];
    } else {
        [FBSession setActiveSession:  [[FBSession alloc] initWithPermissions:permission] ];
        
        [[FBSession activeSession] openWithCompletionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self facebookLoaded];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void) facebookLoaded
{
    
    [SVProgressHUD showWithStatus:MSG_LOADING];
    
    //    JCAppDelegate *delegate = (JCAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@&fields=id,birthday,email,first_name,last_name",[[[FBSession activeSession] accessTokenData] accessToken]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[[FBSession activeSession] accessTokenData] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    // NSLog(@"%@",url);
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedFacebookData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedFacebookData:(NSData *)responseData{
    
    if(responseData.length < 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle: @"Connect Error" message: @"Can't access to Facebook" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
        [alertView show];
        [SVProgressHUD dismiss];
        //        [FBSession setActiveSession:nil];
        return;
    }
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    NSString *photoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=400&height=400",[json objectForKey:@"id"]];
    
    [Engine setMProfilePhotoUrl:photoUrl];
    [self doProcessFBLogin:json login_type: @"facebook"];
    
}
-(void)doProcessFBLogin :(NSDictionary*)inDict login_type:(NSString *)login_type
{
    //NSLog(@"%@",WEB_SERVICES_URL);
    
    
    NSString *gender = @"1";
    if([[inDict objectForKey:@"gender"] isEqualToString:@"male"])
        gender = @"0";
    //NSLog(@"Dictionary%@",inDict);
    NSDictionary* parameters;
    if([login_type isEqualToString:@"facebook"])
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"login_signup",@"type",
                      @"login",@"cmd",
                      @"facebook",@"usertype",
                      [NSString stringWithFormat:@"%f", latitude], @"lat",
                      [NSString stringWithFormat:@"%f", longitude], @"lgn",
                      [inDict objectForKey:@"email"] , @"email",
                      [inDict objectForKey:@"id"],@"facebook_id",
                      gender,@"gender",
                      [inDict objectForKey:@"first_name"] ,@"firstname",
                      [inDict objectForKey:@"last_name"] ,@"lastname",
                      [Engine mProfilePhotoUrl] ,@"photourl",
                      nil];
    [self doFinalizeLogin:parameters];
}
-(void) doFinalizeLogin :(NSDictionary *)parameters
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"user"]];
            
                if([data objectForKey:@"photos"])
                {
                    //   [Engine gPersonInfo].mArrPic =
                    for(int i = 0; i < [[data objectForKey:@"photos"] count]; i++)
                    {
                        JPictureInfo *pCurPhoto = [[JPictureInfo alloc]initWithDictionary:[[data objectForKey:@"photos"] objectAtIndex:i]];
                        [[Engine gPersonInfo].mArrPic addObject:pCurPhoto];
                    }
                }
                [SVProgressHUD dismiss];
                [self onActionShowHome:nil];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            
        }
        
    } failure:nil];
}
@end
