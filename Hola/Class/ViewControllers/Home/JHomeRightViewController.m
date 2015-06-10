//
//  JHomeRightViewController.m
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JHomeRightViewController.h"
#import "Person.h"
#import "JFriendCellTableViewCell.h"
#import "JMatchedFriendTableViewCell.h"
#import "JMatchViewController.h"
#import "JChatViewController.h"
#import "SVPullToRefresh.h"
#import "JChatListCell.h"


#define CONNECTION_SHOWTYPE_MATCH 0
#define CONNECTION_SHOWTYPE_LIKE 1
#define CONNECTION_SHOWTYPE_LIKED 2


@interface JHomeRightViewController ()

@end

@implementation JHomeRightViewController
@synthesize mArrData;
@synthesize mDictData;
@synthesize mArrUserList;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ ( JHomeRightViewController* ) sharedController
{
    __strong static JHomeRightViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JHomeRightViewController alloc ] initWithNibName : @"JHomeRightViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __block JHomeRightViewController *viewController = self;
    [mTvUserList addPullToRefreshWithActionHandler:^{
        [viewController  insertRowAtTop];
    }];
    [mTvUserList addInfiniteScrollingWithActionHandler:^{
        [viewController insertRowAtBottom];
    }];
    [self getUserConnectionDetails:0];
    mArrData = [[NSMutableArray alloc]init];
    mDictData = [[NSMutableDictionary alloc]init];
    mArrUserList = [[NSMutableArray alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([Engine isBackAction] == YES)
    {
        [Engine setIsBackAction: NO];
    }
    else
    {
        //[mTableMatchView reloadData];
        [self getUserConnectionDetails:0];
    }
}
- (void)insertRowAtTop {
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //update
        mPage = 0;
        [self getUserConnectionDetails: mPage];
        [mTvUserList.pullToRefreshView stopAnimating];
    });
}
- (void)insertRowAtBottom {
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //update
        mPage ++;
        [self getUserConnectionDetails: mPage];
        [mTvUserList.infiniteScrollingView stopAnimating];
    });
}
-(void)getUserConnectionDetails :(NSInteger)nPage
{
    if(nPage ==0 && [Engine isBackAction] == NO)
    {
        [Engine setIsBackAction:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSInteger iShowType =  CONNECTION_SHOWTYPE_MATCH;
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:@"chat" forKey:@"type"];
    [parameters setObject:@"get_chat_history" forKey:@"cmd"];
    [parameters setObject:@"all" forKey:@"showtype"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)iShowType] forKey:@"listtype"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)nPage] forKey:@"page"];
    
   // NSLog(@"Result----------------:%@",parameters);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        //NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data=[dict objectForKey:@"data"];
            if ([[data objectForKey:@"page"] isEqualToString:@"0"])
            {
                [mArrData removeAllObjects];
                [mDictData removeAllObjects];
                [mArrUserList removeAllObjects];
            }
            NSArray *feeds = [data objectForKey: @"groups"];
            for (int i = 0; i < [feeds count]; i++)
            {
                NSDictionary *feed = [feeds objectAtIndex: i];
                NSString *partner;
                if([[feed objectForKey:@"partner_id"] isEqualToString:[Engine gPersonInfo].mUserId])
                {
                    partner=[feed objectForKey:@"userid"];
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
                    info=[[JMessageHistoryInfo alloc] initWithDictionary:feed];
                    [mArrData addObject: info];
                    [mDictData setObject:info forKey:partner];
                }
                Person *curPerson = [[Person alloc] initWithDictionary:[feed objectForKey:@"person"]];
                [mArrUserList addObject : curPerson ];
            }
            [mTvUserList reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JChatListCell* cell = [ tableView dequeueReusableCellWithIdentifier : @"JChatListCell" ] ;
    if( cell == nil )
    {
        cell = [ JChatListCell sharedCell];
        //cell.delegate = self;
    }
    else
    {
        NSLog(@"Existing");
    }
    
    JMessageHistoryInfo *info = [mArrData objectAtIndex: indexPath.row];
    [cell setInfo: info];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person * pCurPerson =  [mArrUserList objectAtIndex: indexPath.row];
    [Engine setGCurrentMessageHistory:pCurPerson];
    [Engine setIsBackAction:NO];
    JChatViewController *pMatchView = [JChatViewController sharedController];
    [self.navigationController pushViewController:pMatchView animated:YES];
    [mTvUserList deselectRowAtIndexPath:indexPath animated:YES];
}
@end
