//
//  JFriendListViewController.m
//  Hola
//
//  Created by Jin Wang on 5/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JFriendListViewController.h"
#import "JFriendCellTableViewCell.h"
#import "LocalNotification.h"

#import "JMatchViewController.h"
#import "JChatViewController.h"
#import "SVPullToRefresh.h"

#define CONNECTION_SHOWTYPE_MATCH 0
#define CONNECTION_SHOWTYPE_ALL 3

@interface JFriendListViewController ()

@end

@implementation JFriendListViewController
@synthesize mArrMatchList;

+ ( JFriendListViewController* ) sharedController
{
    __strong static JFriendListViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JFriendListViewController alloc ] initWithNibName : @"JFriendListViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mArrMatchList = [[NSMutableArray alloc]init];
    
    __block JFriendListViewController *viewController = self;
    [mTvUserList addPullToRefreshWithActionHandler:^{
        [viewController  insertRowAtTop];
        [mTvUserList showsInfiniteScrolling];
    }];
    [mTvUserList addInfiniteScrollingWithActionHandler:^{
        [viewController insertRowAtBottom];
    }];

    [self getUserConnectionDetails:0];
    [noMatchesLabel setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([Engine isBackAction] == YES)
    {
        [Engine setIsBackAction: NO];
    }
    else
    {
        [mTvUserList triggerPullToRefresh];
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
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //update
        mPage ++;
        [self getUserConnectionDetails: mPage];
        [mTvUserList.infiniteScrollingView stopAnimating];
    });
}

-(void)getUserConnectionDetails:(NSInteger)nPage
{
    if(nPage ==0 && [Engine isBackAction] == NO)
    {
        [Engine setIsBackAction:YES];
    }
    NSInteger iShowType =  CONNECTION_SHOWTYPE_ALL;
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:@"connection" forKey:@"type"];
    [parameters setObject:@"get_list" forKey:@"cmd"];
    [parameters setObject:@"all" forKey:@"showtype"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)iShowType] forKey:@"listtype"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)nPage] forKey:@"page"];
    
    //NSLog(@"Result----------------:%@",parameters);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        
        NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        if ([res isEqualToString: @"1"])
        {
            
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            if([error1 isEqualToString:@"1"])
            {
                [LocalNotification showNotificationWithString:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                
                NSArray *postList = [data objectForKey:@"result"];

                if(iShowType == CONNECTION_SHOWTYPE_ALL)
                {
                    if(nPage == 0)
                    {
                        [mArrMatchList removeAllObjects];
                    }
                    NSMutableDictionary *pDict;
                     NSLog(@"postList%@", [data objectForKey:@"result"]);
                    for(pDict in postList)
                    {
                        Person  *p = [[Person alloc]initWithDictionary:pDict];
                        [mArrMatchList addObject:p];
                    }
                }
                if ([mArrMatchList count] < 1){
                    [noMatchesLabel setHidden:NO];
                }
                else {
                    [noMatchesLabel setHidden:YES];
                }
                [mTvUserList reloadData];
            }
        }
        else
        {
            [LocalNotification showNotificationWithString:MSG_SERVICE_UNAVAILABLE];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LocalNotification showNotificationWithString:MSG_SERVICE_UNAVAILABLE];
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrMatchList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ViewCell = @"JFriendCellTableViewCell";
    JFriendCellTableViewCell *cell = (JFriendCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ViewCell ];
    if(cell == nil)
    {
        if( cell == nil )
        {
            cell = [ JFriendCellTableViewCell sharedCell];
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:251/255.0f green:107/255.0f blue:97/255.0f alpha:1];
            [cell setSelectedBackgroundView:bgColorView];
        }
    }
    @try {
        [cell setInfo:[mArrMatchList objectAtIndex:indexPath.row]];
        return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
    }
    @finally {
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person * pCurPerson =  [mArrMatchList objectAtIndex: indexPath.row];
    [Engine setGCurrentMessageHistory:pCurPerson];
    [Engine setIsBackAction:NO];
    JChatViewController *pMatchView = [JChatViewController sharedController];
    [self.navigationController pushViewController:pMatchView animated:YES];
    [mTvUserList deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(IBAction)onTouchBtnLeftMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
}
-(IBAction)onTouchBtnRightMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_RIGHTBTN_TOUCH object: nil];
}
@end
