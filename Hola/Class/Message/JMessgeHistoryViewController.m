//
//  JMessgeHistoryViewController.m
//  GoSteady
//
//  Created by Jing on 3/31/14.
//  Copyright (c) 2014 Jing Mobile. All rights reserved.
//

#import "JMessgeHistoryViewController.h"

#import "AppEngine.h"
#import "Constants.h"

#import "SBJson.h"
#import "MBProgressHUD.h"

#import "SVPullToRefresh.h"

#import "JChatViewController.h"
#import "JChatListCell.h"




@interface JMessgeHistoryViewController ()

@end

@implementation JMessgeHistoryViewController
@synthesize mArrData;
@synthesize mDictData;


+ ( JMessgeHistoryViewController* ) sharedController
{
	__strong static JMessgeHistoryViewController* sharedController = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        sharedController = [ [ JMessgeHistoryViewController alloc ] initWithNibName : @"JMessgeHistoryViewController" bundle : nil ] ;
	} ) ;
    
    return sharedController ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)initViewController:(id)sender
{
    //    [mArrData removeAllObjects];
    
    [mArrData removeAllObjects];
    [mDictData removeAllObjects];
    //    [mTView reloadData];
    
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(initViewController:) name: NOTIFICATION_LOGOUT object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handlePushNotification:) name: NOTIFICATION_ACTION object: nil];
    [super viewDidLoad];
    
    
    // mArrData = [Engine gContactsArr];
    // mDictData=[Engine gContactsDict];
    
    mArrData = [[NSMutableArray alloc]init];
    mDictData= [[NSMutableDictionary alloc]init];
    
    
    mProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mProgress.mode = MBProgressHUDModeIndeterminate;
    [mProgress hide: NO];
    
    [self sendGetHistoryRequest:0];
    __block JMessgeHistoryViewController *viewController = self;
    
    [mTView addPullToRefreshWithActionHandler:^{
        [viewController insertRowAtTop];
    }];
}



- (void)handlePushNotification: (NSNotification *)notification
{

    [self reloadMessageHistory];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendGetHistoryRequest:0];

    [mTView reloadData];
}

-(void) reloadMessageHistory
{
    //    mPage = 0;
    //    [mTView reloadData];
    [self sendGetHistoryRequest:mPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//#pragma mark -
//#pragma mark - SVPullToRefresh

- (void)insertRowAtTop {
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //update
        mPage = 0;
        
        [self sendGetHistoryRequest: mPage];
        [mTView.pullToRefreshView stopAnimating];
    });
}


#pragma mark -
#pragma mark - Touch Event


-(IBAction)onTouchBtnHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HOME_LEFTBTN_TOUCH object:sender];
}
-(IBAction)onTouchBtnFindUser:(id)sender
{
 //   JFindFriendViewController* findView=[JFindFriendViewController sharedController];
 //   [self.navigationController pushViewController:findView animated:YES];
}
-(IBAction)onTouchBtnSetting:(id)sender
{
//    JSettingsViewController* findView=[JSettingsViewController sharedController];
//    [self.navigationController pushViewController:findView animated:YES];
}

-(IBAction)onTouchBtnHep:(id)sender
{
//    JAlphaHandViewController* handView=[JAlphaHandViewController sharedController];
//    [self.navigationController pushViewController:handView animated:YES];
}

#pragma mark - Send Request To API

- (void)sendRequestBlockUser
{
    
    //    [mProgress show:YES];
    
    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"block_user",@"cmd",[Engine gPersonInfo].mUserId,@"user_id",[Engine gPersonInfo].mSessToken,@"sess_token",actionToTaken.userid,@"partner_id", nil];//[Engine gPersonInfo].mLat
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //        [mProgress hide: YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    [mArrData removeObject:actionToTaken];
    [mTView reloadData];
    
}

- (void)sendGetHistoryRequest: (int) page
{
    //    [mProgress show: YES];
    
//    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"send_message",@"cmd",[Engine gPersonInfo].mUserId, @"userid",[Engine gPersonInfo].mSessToken,@"sesstoken",chatPartner.mUserId,@"partner_id",[NSString stringWithFormat: @"%d", mPointer],@"pointer", MESSAGE_TYPE_NOTE,@"msgtype",[Engine base64Encode:trimmedString],@"msg", nil];//[Engine gPersonInfo].mLat
//    
//
//    
    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"get_chat_history",@"cmd",[Engine gPersonInfo].mUserId,@"userid",[Engine gPersonInfo].mSessToken,@"sesstoken",[NSString stringWithFormat: @"%d", page],@"page", nil];//[Engine gPersonInfo].mLat

    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //        [mProgress hide: YES];
        NSData *data=(NSData*)responseObject;
        NSLog(@"respnose=%@",[NSString stringWithUTF8String:data.bytes]);
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary *dict = (NSDictionary*)responseObject;
        NSLog(@"response=%@", dict);
        NSString *res = [dict objectForKey: @"success"];
        
        if ([res isEqualToString: @"1"])
        {
            NSDictionary *data=[dict objectForKey:@"data"];
            if ([[data objectForKey:@"page"] isEqualToString:@"0"])
            {
                [mArrData removeAllObjects];
                [mDictData removeAllObjects];
            }
            
            NSArray *feeds = [data objectForKey: @"groups"];
            
            for (int i = 0; i < [feeds count]; i++)
            {
                NSDictionary *feed = [feeds objectAtIndex: i];
                NSString *partner;
                if([[feed objectForKey:@"partner_id"] isEqualToString:[Engine gPersonInfo].mUserId])
                {
                    partner=[feed objectForKey:@"user_id"];
                }
                else
                {
                    partner=[feed objectForKey:@"partner_id"];
                }
                JMessageHistoryInfo *info;
                info=[mDictData objectForKey:partner];
                if(info)
                {
                    [info setDataWithDictionary:feed];
                }
                else
                {
                    NSLog(@"history info%@",feed);
                    info=[[JMessageHistoryInfo alloc] initWithDictionary:feed];
                    [mArrData addObject: info];
                    [mDictData setObject:info forKey:partner];
                }
            }
            [mTView reloadData];
        }
        
        [Engine setGSrvTime: [dict objectForKey: @"current_time"]];
        
        [mProgress hide: YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    [mArrData removeObject:actionToTaken];
    [mTView reloadData];
    
}

#pragma tableview delegate

#pragma table datasource delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JChatListCell* cell = [ tableView dequeueReusableCellWithIdentifier : @"JChatListCell" ] ;
    
    if( cell == nil )
    {
        cell = [ JChatListCell sharedCell];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    else
    {
        NSLog(@"Existing");
    }
    
    JMessageHistoryInfo *info = [mArrData objectAtIndex: indexPath.row];
    
    [cell setInfo: info];
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Block"];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    //                                                title:@"Delete"];
    
    return rightUtilityButtons;
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"Block button was pressed");
            NSIndexPath *cellIndexPath = [mTView indexPathForCell:cell];
            actionToTaken=[mArrData objectAtIndex: cellIndexPath.row];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Block this user" message: @"Are you sure you want to block this user? This action can not be undone." delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Yes", nil];
            [alertView show];
        }
        case 1:
        {
            NSLog(@"Delete button was pressed");
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [mTView indexPathForCell:cell];
            actionToTaken=[mArrData objectAtIndex: cellIndexPath.row];
            
            //            [self sendRequestDeleteHistory];
            break;
        }
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self sendRequestBlockUser];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMessageHistoryInfo* info=[mArrData objectAtIndex:indexPath.row];
    [Engine setIsBackAction:NO];
    [Engine setGCurrentMessageHistory:info];
    JChatViewController *singleView=[JChatViewController sharedController];
    [self.navigationController pushViewController:singleView animated:YES];
    
    
}
-(IBAction)onTouchBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
