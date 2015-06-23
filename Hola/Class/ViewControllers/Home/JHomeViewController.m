//
//  JHomeViewController.m
//  Hola
//
//  Created by Jin Wang on 2/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JHomeViewController.h"
#import "JHomeDetailViewController.h"
#import "Person.h"
#import "JMatchViewController.h"
#import "DataService.h"

@interface JHomeViewController ()

@end

@implementation JHomeViewController {
    NSTimer *timer;
}

@synthesize people;
@synthesize currentPerson;
@synthesize frontCardView;
@synthesize backCardView;
@synthesize mArrUsers;

+ ( JHomeViewController* ) sharedController
{
    __strong static JHomeViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JHomeViewController alloc ] initWithNibName : @"JHomeViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}

- (void)viewWillDisappear:(BOOL)animated {
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    timer = [NSTimer scheduledTimerWithTimeInterval:5
                                             target:self
                                           selector:@selector(redisplayUserFeed:)
                                           userInfo:nil
                                            repeats:YES];
        [mImgUserPhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     mArrUsers = [[NSMutableArray alloc]init];
    recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBtnDetail:)];
    recognizer.numberOfTouchesRequired=1;
    recognizer.delegate=self;
    [frontCardView setUserInteractionEnabled:YES];
    
    waveLayer=[CALayer layer];
    waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius = 4;
    [mViewSearchContainer.layer addSublayer:waveLayer];
    [waveLayer setHidden:NO];
    
    int screenWidth = [self.view bounds].size.width;
    int containerHeight = mViewSearchContainer.frame.size.height;
    
    int xPos = screenWidth / 2 - 4;
    int yPos = containerHeight / 2 - 45;


    
    if (IS_IPHONE5) {
        waveLayer.frame = CGRectMake(xPos, yPos, 8, 8);
    }else{
        waveLayer.frame = CGRectMake(xPos, yPos, 8, 8);
    }
    
    
    
    [self.view addSubview:  mViewSearchContainer];
    
    [mViewSearchContainer setFrame:CGRectMake(0, self.view.frame.size.height - mViewSearchContainer.frame.size.height , mViewSearchContainer.frame.size.width, mViewSearchContainer.frame.size.height)];
    [mImgUserPhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    [mViewSearchContainer bringSubviewToFront:mImgUserPhoto];
    
    [mImgUserPhoto.layer setCornerRadius:mImgUserPhoto.frame.size.height / 2];
    [mImgUserPhoto.layer setMasksToBounds:YES];
    
    [self startAnimation:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:YES];

    if([Engine bUserSettingChanged] == YES)
    {
        [self setRadarViewAlphaTo:1.0f];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mArrUsers removeAllObjects];
        self.frontCardView = nil;
        self.backCardView = nil;
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
        [Engine setBUserSettingChanged:NO];
    }
    if([Engine isBackAction])
    {
        [Engine setIsBackAction:NO];
    }
}

-(void)redisplayUserFeed:(id)sender
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (mArrUsers.count == 0 && !self.frontCardView) {
        [self setRadarViewAlphaTo:1.0f];
        [Engine setBUserSettingChanged:NO];
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
        [self getMatchedUsers];
    }
}

-(void) setRadarViewAlphaTo:(float)alpha{
    [UIView animateWithDuration:0.3 animations:^() {
        mViewSearchContainer.alpha = alpha;
    }];
}
-(void) getMatchedUsers
{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:@"dating" forKey:@"type"];
    [parameters setObject:@"get_matched_users" forKey:@"cmd"];
    
    DataService *dataService = [DataService sharedDataService];
    [dataService postWithParameters:parameters successHandler:^(NSArray *pUserArr) {
        for(NSDictionary *pCurDict in pUserArr)
        {
            Person *pCurPerson = [[Person alloc]initWithDictionary:pCurDict];
            [mArrUsers addObject:pCurPerson];
        }
        if([mArrUsers count] > 0)
        {
            [self setRadarViewAlphaTo:0.0f];
            [self showUsers];
        }
        else
        {
            [self setRadarViewAlphaTo:1.0f];
        }
    } currentView:self.view];
}



-(void)showUsers
{
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];

    [frontCardView addGestureRecognizer:recognizer];
    
//    [self.view addSubview:self.frontCardView];
    [self.view insertSubview:self.frontCardView belowSubview:mViewSearchContainer];
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.backCardView setBackgroundColor:[UIColor grayColor]];
    
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    [self.frontCardView.layer setBorderWidth:0.0f];
    [self.backCardView.layer setBorderWidth:0.0f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    
    NSInteger status = 0;
    if (direction == MDCSwipeDirectionLeft) {
        status = 2;
    } else {
        status = 1;
    }
    if(status == 1 && frontCardView.person.likeorder == 1) //push notification should be sent
    {
        JMatchViewController *pMatchView = [JMatchViewController sharedController];
        [pMatchView setMCurrentPerson: frontCardView.person];
        [self.navigationController pushViewController:pMatchView animated:YES];
    }

    [Engine setIsBackAction:NO];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self setUserLikeStatus:status personid:self.frontCardView.person.userid];
    
    self.frontCardView = self.backCardView;
    if(!self.backCardView)
    {
        [self setRadarViewAlphaTo:1.0f];
    }
    [frontCardView addGestureRecognizer:recognizer];
    
    [self.frontCardView.layer setBorderWidth:0.0f];

//    if([mArrUsers count] == 0)
//        [mViewSearchContainer setHidden:NO];
    
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.backCardView.layer setBorderWidth:0.0f];
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }else {
        self.backCardView = nil;
    }
 }


- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.mArrUsers count] == 0) {
        return nil;
    }
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y, //- (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    
    
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.mArrUsers[0]
                                                                   options:options];
     //[personView addGestureRecognizer:recognizer];
    [self.mArrUsers removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 81.f;
    CGFloat bottomPadding = 250.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2) - 10,
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y, //  + 10,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}
-(void)onTouchBtnDetail:(id)sender
{
    JHomeDetailViewController *pDetailView = [JHomeDetailViewController sharedController];
    if(!frontCardView.person || !frontCardView.person.userid)
        return;
    [pDetailView setMUserId:[NSString stringWithFormat :@"%d", (int)frontCardView.person.userid]];
    [pDetailView setMCurPerson:frontCardView.person];
    [self.navigationController pushViewController:pDetailView animated:YES];
    
}
-(IBAction)onTouchBtnYes:(id)sender
{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}
-(IBAction)onTouchBtnNo:(id)sender
{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}
-(IBAction)onTouchBtnLeftMenu:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
    
    
}
-(IBAction)onTouchBtnRightMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_RIGHTBTN_TOUCH object: nil];
}
-(void) setUserLikeStatus:(NSInteger)status personid:(NSInteger)personid
{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:[NSString stringWithFormat:@"%d",(int)status ] forKey:@"status"];
    [parameters setObject:[NSString stringWithFormat:@"%d",(int)personid ] forKey:@"person_id"];
    [parameters setObject:@"dating" forKey:@"type"];
    [parameters setObject:@"set_user_like_status" forKey:@"cmd"];
    //    [SVProgressHUD showWithStatus:MSG_WAIT maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([[data objectForKey:@"error"] isEqualToString:@"0"])
                {
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }
            }
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark wave search page
-(void)startAnimation:(NSTimer *)timer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self performSelector:@selector(waveAnimation:) withObject:waveLayer ];
    
    
}
-(void)waveAnimation:(CALayer*)aLayer
{
    //[mImageViewSelf setHidden:NO];
    //    if([[Engine gMatchedPeopleList] count] > 0)
    //        return;
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = 3;
    
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnimation.removedOnCompletion = YES;
    transformAnimation.fillMode = kCAFillModeRemoved;
    [aLayer setTransform:CATransform3DMakeScale( 0, 0, 1.0)];
    [transformAnimation setDelegate:self];
    
    CATransform3D xform = CATransform3DIdentity;
    xform = CATransform3DScale(xform, 40, 40, 1.0);
    //xform = CATransform3DTranslate(xform, 60, -60, 0);
    transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
    [aLayer addAnimation:transformAnimation forKey:@"transformAnimation"];
    
    
    UIColor *fromColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    UIColor *toColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 3;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    [aLayer addAnimation:colorAnimation forKey:@"colorAnimationBG"];
    UIColor *fromColor1 = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    UIColor *toColor1 = [UIColor colorWithRed:255 green:0 blue:0 alpha:0];
    CABasicAnimation *colorAnimation1 = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation1.duration = 3;
    colorAnimation1.fromValue = (id)fromColor1.CGColor;
    colorAnimation1.toValue = (id)toColor1.CGColor;
    
    [aLayer addAnimation:colorAnimation1 forKey:@"colorAnimation"];
    [self performSelector:@selector(waveAnimation:) withObject:waveLayer afterDelay:3];

}


@end
