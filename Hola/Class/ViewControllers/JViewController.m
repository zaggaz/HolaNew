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

#import "JSearchViewController.h"
#import "JMessgeHistoryViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface JViewController ()

@end

@implementation JViewController
@synthesize locationManager;

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
    
    [mBtnFacebookLogin.layer setCornerRadius:3.0f];
    [mBtnFacebookLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnFacebookLogin.layer setBorderWidth:1.0f];
    
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
                
                [self onActionShowHome:nil];
            }
        }
        
    }
}


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
    [Engine gPersonInfo].mUserId=nil;
    
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
#pragma mark login
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
    NSString *photoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200",[json objectForKey:@"id"]];
    
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
