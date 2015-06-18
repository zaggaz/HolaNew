//
//  JChatViewController.m
//  Hola
//
//  Created by Jin Wang.
//  Copyright (c) 2015 e. All rights reserved.
//
#import "JChatViewController.h"
#import "HPGrowingTextView.h"

#import "JMyActionSheet.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "SBJsonWriter.h"
#import "MBProgressHUD.h"
#import "JMessgeHistoryViewController.h"
#import "JChatTableCell.h"
#import "JHomeDetailViewController.h"

#define THUMBNAIL_WIDTH 150.0
#define THUMBNAIL_HEIGHT 150.0
#define PREFERED_WIDTH 480
#define PREFERED_HEIGHT 480
#define PREFERED_RATIO 1//1136.0/640.0


@interface JChatViewController ()

@end

@implementation JChatViewController
@synthesize mFileNameToUpload;
@synthesize mImageSmall;
@synthesize mImageBig;

+ ( JChatViewController* ) sharedController
{
    __strong static JChatViewController* sharedController = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JChatViewController alloc ] initWithNibName : @"JChatViewController" bundle : nil ] ;
    } ) ;
    return sharedController ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];

    
    //    mTView.scrollsToTop=NO;
    
    mArrChatMsg = [[NSMutableArray alloc] init];
    mArrDate = [[NSMutableArray alloc] init];
    
    mImgAnnot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    mImgAnnot.layer.cornerRadius=12;
    mImgAnnot.layer.masksToBounds=YES;
    
    UITapGestureRecognizer* recognizer;
    recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground:)];
    recognizer.numberOfTouchesRequired=1;
    recognizer.delegate=self;
    [mTView addGestureRecognizer:recognizer];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 8, 220, 15)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.internalTextView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    textView.font = [UIFont fontWithName:@"Lato-regular" size:14];
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.internalTextView.layer.masksToBounds=YES;
    textView.internalTextView.clipsToBounds=YES;
    textView.internalTextView.scrollEnabled=NO;
    textView.placeholder = @"Say something...";
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setBackgroundColor:[UIColor whiteColor]];
    [mViewForChat insertSubview:textView belowSubview:mBlankFrame];
    mBlankFrame.image = [[UIImage imageNamed:@"bgTextField_InnerBlank.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 10, 26, 10)];
    
    textView.layer.masksToBounds=YES;
    mViewForChat.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    current_Run=0;
    
    mActivityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-5, (mBtnSend.frame.size.height-20)/2, 20, 20)];
    mActivityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [mBtnSend addSubview:mActivityIndicator];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateTopBadge:) name: UPDATE_TOP_BADGE object: nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(IBAction)onTouchBtnLeftMenu:(id)sender
{
  //  [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onTouchBtnProfile:(id)sender
{
    JHomeDetailViewController *pHomeDetail = [JHomeDetailViewController sharedController];
    [pHomeDetail setMCurPerson:chatPartner];
    [pHomeDetail setMUserId:[NSString stringWithFormat: @"%ld", (long)chatPartner.userid]];
    
    [self.navigationController pushViewController:pHomeDetail animated:YES];
}

-(void)updateTopBadge:(id)sender
{
    //[Engine checkAndUpdateBadge:mUnreadMsgCount];
}

-(void) keyboardWillShow:(NSNotification *)note{
    //    return;
    // get keyboard size and loctaion
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = mViewForChat.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    mViewForChat.frame = containerFrame;
    CGRect tableViewFrame = mTView.frame;
    tableViewFrame.size.height = containerFrame.origin.y-tableViewFrame.origin.y;
    mTView.frame = tableViewFrame;
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    //    return;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect containerFrame = mViewForChat.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    //
    //	// set views with new info
    mViewForChat.frame = containerFrame;
    
    CGRect tableViewFrame = mTView.frame;
    tableViewFrame.size.height = containerFrame.origin.y-tableViewFrame.origin.y;
    mTView.frame = tableViewFrame;
    //	// commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = mViewForChat.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    mViewForChat.frame = r;
    [mTView setContentInset:UIEdgeInsetsMake(0, 0, mTView.frame.size.height+mTView.frame.origin.y- r.origin.y  , 0)];
    mTView.scrollIndicatorInsets = mTView.contentInset;
}
-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if(!growingTextView.hidden)
    {
        if([growingTextView.text isEqualToString:@""])
        {
            [mBtnSend setEnabled:NO];
        }
        else
        {
            [mBtnSend setEnabled:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    mIsRunning=TRUE;
    current_Run++;
    
    if([Engine isBackAction])
    {
        [self performSelectorInBackground: @selector(updateChatData:) withObject: [NSNumber numberWithInt:current_Run]];
    }
    else
        [self initView];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"chat_overlay_status"] isEqualToString:@"1"])
        [self showOverlay];
    
    //    chatPartner=[Engine gCurrentMessageHistory];
    [mFullPhoto.layer setCornerRadius:mFullPhoto.frame.size.width / 2];
    [mFullPhoto.layer setMasksToBounds:YES];
        [mFullPhoto setImageWithURL:[NSURL URLWithString:[Engine gCurrentMessageHistory].photourl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
}

- ( void ) viewWillDisappear : ( BOOL ) _animated
{
    [ super viewWillDisappear : _animated ] ;
    //    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    current_Run++;
    mIsRunning=FALSE;
    
}


- (void)loadDataFromCore
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSError *error;
    
    
    // Retrieve the entity from the local store -- much like a table in a database
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Set the predicate -- much like a WHERE statement in a SQL database
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partner_id == %d", chatPartner.userid];
    
    [request setPredicate:predicate];
    
    // Set the sorting -- mandatory, even if you're fetching a single record/object
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgdate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //    [[Engine mMissionaryList] addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    NSArray *mArr=[context executeFetchRequest:request error:&error];
    
    //    [sortDescriptors release];
    sortDescriptors = nil;
    //    [sortDescriptor release];
    sortDescriptor = nil;
    NSManagedObject *object;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy"];
    for (int i=0; i<[mArr count]; i++) {
        JMessageInfo *info=[[JMessageInfo alloc] init];
        object=[mArr objectAtIndex:i];
        info.mMsg=[Engine base64Decode:[object valueForKey:@"message"]];
        info.mMsgType=[object valueForKey:@"msgtype"];
        
        info.mFileUrl = [object valueForKey:@"fileurl"];
        NSNumber *number=[object valueForKey:@"msgdate"];
        info.mTimeStamp=[NSString stringWithFormat:@"%@",number];
        number=[object valueForKey:@"sender_id"];
        info.mUserId=[NSString stringWithFormat:@"%@",number];
        info.mPartnerId = [NSString stringWithFormat:@"%@",[object valueForKey:@"partner_id"]];
        
        //        [mArrChatMsg addObject:info];
        
        
        mLastTimestamp=[info.mTimeStamp intValue];
        mLastMessageId=info.mUserId;
        mPointer=mLastTimestamp;
        
        NSTimeInterval epoch = [info.mTimeStamp doubleValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
        
        if ([self isExistDate: [formatter stringFromDate: date]])
        {
            int idx = [mArrDate indexOfObject: [formatter stringFromDate: date]];
            
            [[mArrChatMsg objectAtIndex: idx] addObject: info];
        }
        else
        {
            [mArrDate addObject: [formatter stringFromDate: date]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject: info];//[NSString stringWithFormat:@"%@",date]] ;
            [mArrChatMsg addObject: arr];
        }
        
    }
    [mTView reloadData];
    if([mArrDate count]>0)
    {
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:[[mArrChatMsg objectAtIndex: mArrDate.count - 1] count] - 1
                                                       inSection: [mArrDate count] - 1];
        
        [mTView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:NO];
    }
    else
    {
        [mTView scrollRectToVisible:CGRectMake(0, 0, mTView.frame.size.width, 10) animated:NO];
        
    }
    first_message=0;
    [self performSelectorInBackground: @selector(updateChatData:) withObject: [NSNumber numberWithInt:current_Run]];
    
}


- (void)initView
{
    chatPartner=[Engine gCurrentMessageHistory];
    mIsPause=NO;
    mIsPhotoUploading=NO;
    [mArrChatMsg removeAllObjects];
    [mArrDate removeAllObjects];
    [mTView reloadData];
    mLastTimestamp=0;
    mLastMessageId=@"";
    mIsRunning = YES;
    requestSent=0;
    [textView setText:@""];
    [textView refreshHeight];
    mPhotoNotification.alpha=0;
    mBtnPhotoSend.enabled=YES;
    mPointer = 0;
    
    [textView setHidden:NO];
    [mImgButtonView setHidden:YES];
    [mImgPreview setImage:nil];
    [mFullPhotoView setHidden:YES];
    if(chatPartner.mNewMsgNum && ![chatPartner.mNewMsgNum isEqualToString:@"0"])
    {
        chatPartner.mNewMsgNum=@"0";
        int count=[[Engine gNewMessagesCount] intValue]-1;
        if(count<0)
        {
            count=0;
        }
        [Engine setGNewMessagesCount:[NSString stringWithFormat:@"%d",count]];
        [[NSNotificationCenter defaultCenter] postNotificationName: UPDATE_TOP_BADGE object: nil];
    }
    [mLblUserName setText:chatPartner.name];
    mImgAnnot.image=nil;
    [mBtnSend setEnabled:NO];
    [self loadDataFromCore];
    
}

-(void)showPhotoNotification
{
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mPhotoNotification.alpha=1;
                         //                         mMemeView.transform=CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         //                         [mMemeView setHidden:YES];
                     }];
}
-(void)hidePhotoNotification
{
    [mBtnPhotoSend setEnabled:YES];
    [UIView animateWithDuration:0.4f
                          delay:1.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mPhotoNotification.alpha=0;
                         //                         [mMemeView setFrame:CGRectMake(0, mTView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-mTView.frame.origin.y)];
                         //                         mMemeView.transform=CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         //                         [mMemeView setHidden:YES];
                     }];
}

-(void)hideShareView{
}
-(void)showShareView{
    
}
- (void)showPicker:(UIView *)picker show:(BOOL)bShow animated:(BOOL)bAnimated
{
    if (bAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
    }
    
    if (bShow) {
        
        picker.frame = CGRectMake(0, self.view.frame.size.height - picker.frame.size.height, picker.frame.size.width, picker.frame.size.height);
        
        [self.view bringSubviewToFront:picker];
    }
    else {
        picker.frame = CGRectMake(0, self.view.frame.size.height, picker.frame.size.width, picker.frame.size.height);
    }
    
    if (bAnimated) {
        [UIView commitAnimations];
    }
}


#pragma mark - Showing And Hiding Meme
-(void)onTapBackground:(id)sender
{
    [mViewForChat endEditing:YES];
}

-(IBAction)onTouchBtnHep:(id)sender
{
    
}

-(IBAction)onTouchBtnSelectColor:(id)sender
{
    
}
-(void)didColorModeClickCancel
{
    
}
-(void)didColorModeClickDone:(NSString *)color
{
    
}

#pragma mark -
#pragma mark - Fetch Chat Message from server

- (void) updateChatData:(NSNumber*)currentRun
{
    //    if([mArrDate count]>0)
    //        sleep(5);
    int c_run=[currentRun intValue];
    while (mIsRunning && (current_Run==c_run)) {
        //        if()
        //        {
        if (mIsPause)
        {
            sleep(1);
            continue;
        }
        [self sendRequestFetchMessage: mPointer];
        //        NSLog(@"Sending a new request in %dth Run:",c_run);
        sleep(3);
        //        }
    }
}
#pragma mark -
#pragma mark - Send request to server

- (void)sendRequestBlockUser
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    mIsRunning=FALSE;
    
    
    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:
                              @"chat",@"type"
                              ,@"block_user",@"cmd"
                              ,[Engine gPersonInfo].mUserId,@"userid"
                              ,[Engine gPersonInfo].mSessToken,@"sess_token"
                              ,[NSString stringWithFormat:@"%ld", (long)chatPartner.userid],@"partner_id", nil];//[Engine gPersonInfo].mLat
    
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
            [mViewForChat endEditing:YES];
            [Engine setIsBackAction:YES];
            [self.navigationController popViewControllerAnimated:YES];
            JMessgeHistoryViewController *viewController=[JMessgeHistoryViewController sharedController];
            [viewController.mArrData removeObject:chatPartner];
            [Engine setIsBackAction:YES];
        }
        [Engine setGSrvTime: [dict objectForKey: @"current_time"]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    //    [mTView reloadData];
    
}

-(void)processReceivedMessages:(NSDictionary*)data
{
    //    NSDictionary *data = [dict objectForKey: @"data"];
    NSArray *messages = [data objectForKey: @"messages"];
    NSLog(@"Get Data %@",data);
    BOOL alreadyLoaded=NO;
    if([mArrDate count]>0)
    {
        alreadyLoaded=YES;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSError *error;
    
    
    for (int i = 0; i < [messages count]; i++)
    {
        NSDictionary *dicMsg = [messages objectAtIndex: i];
        int mTimestamp = [[dicMsg objectForKey: @"msgdate"] intValue];
        if((mTimestamp < mLastTimestamp)||([[dicMsg objectForKey:@"id"] isEqualToString:mLastMessageId]))
        {
            continue;
        }
        mLastTimestamp=mTimestamp;
        mLastMessageId=[dicMsg objectForKey:@"id"];
        JMessageInfo *info = [[JMessageInfo alloc] initWithDictionary:dicMsg];
        NSTimeInterval epoch = [[dicMsg objectForKey: @"msgdate"] doubleValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat: @"MM/dd/yyyy"];
        if ([self isExistDate: [formatter stringFromDate: date]])
        {
            int idx = [mArrDate indexOfObject: [formatter stringFromDate: date]];
            //                [[mArrChatMsg objectAtIndex: idx] addObject: info];
            [[mArrChatMsg objectAtIndex: idx] addObject: info];
        }
        else
        {
            [mArrDate addObject: [formatter stringFromDate: date]];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject: info];
            [mArrChatMsg addObject: arr];
        }
        
        NSManagedObject *messageInfo= [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Messages"
                                       inManagedObjectContext:context];
        
        [messageInfo setValue: [dicMsg objectForKey:@"message"]  forKey: @"message"];
        [messageInfo setValue: [dicMsg objectForKey:@"msgtype"] forKey:@"msgtype"];
        [messageInfo setValue: [NSNumber numberWithDouble:[[dicMsg objectForKey:@"id"] intValue]] forKey:@"id"];
        [messageInfo setValue: [NSNumber numberWithDouble:[[dicMsg objectForKey:@"msgdate"] intValue]] forKey:@"msgdate"];
        
        
        [messageInfo setValue: [NSNumber numberWithDouble:[info.mUserId intValue]] forKey:@"sender_id"];
        [messageInfo setValue: [NSNumber numberWithDouble:[info.mPartnerId intValue]] forKey:@"partner_id"];
        [messageInfo setValue: [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/", [dicMsg objectForKey:@"fileurl"]] forKey:@"fileurl"];
        //            [mArrChatMsg addObject: info];
    }
    
    
    mPointer = [[data objectForKey: @"pointer"] intValue];
    [mTView reloadData];
    
    
    //        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:mArrChatMsg.count-1
    //                                                       inSection:0];
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:[[mArrChatMsg objectAtIndex: mArrDate.count - 1] count] - 1
                                                   inSection: [mArrDate count] - 1];
    
    [mTView scrollToRowAtIndexPath:topIndexPath
                  atScrollPosition:UITableViewScrollPositionMiddle
                          animated:alreadyLoaded];//if already loaded is true, then it should animate to that point, if that's not the case, it should already be there.
    if([messages count]>0)
    {
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    if(([messages count]>0)&&(first_message!=1))
    {
        
    }
    
}
- (void)sendRequestFetchMessage: (int)pointer
{
    
    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"read_message",@"cmd",[Engine gPersonInfo].mUserId,@"userid",[Engine gPersonInfo].mSessToken,@"sesstoken",[NSString stringWithFormat:@"%ld", (long)chatPartner.userid],@"partner_id",[NSString stringWithFormat: @"%d", pointer],@"pointer", nil];//[Engine gPersonInfo].mLat
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //        [mProgress hide: YES];
        NSData *data=(NSData*)responseObject;
        NSLog(@"response=%@",[NSString stringWithUTF8String:data.bytes]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary *dict = (NSDictionary*)responseObject;
        
        NSString *res = [dict objectForKey: @"success"];
        
        if ([res isEqualToString: @"1"])
        {
            NSDictionary *data = [dict objectForKey: @"data"];
            [self processReceivedMessages:data];
        }
        [Engine setGSrvTime: [dict objectForKey: @"current_time"]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)sendMessage:(NSString*)msgType
{
    mIsPause = YES;
    
    NSString *str=[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *trimmedString = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@" "];
    
    if(([msgType isEqualToString:MESSAGE_TYPE_NOTE])&&([trimmedString isEqualToString:@""]))
    {
        return;
    }
    NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"send_message",@"cmd",[Engine gPersonInfo].mUserId, @"userid",[Engine gPersonInfo].mSessToken,@"sesstoken",[NSString stringWithFormat:@"%ld", (long)chatPartner.userid],@"partner_id",[NSString stringWithFormat: @"%d", mPointer],@"pointer", MESSAGE_TYPE_NOTE,@"msgtype",[Engine base64Encode:trimmedString],@"msg", nil];//[Engine gPersonInfo].mLat
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [mActivityIndicator stopAnimating];
        NSData *data=(NSData*)responseObject;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary *dict = (NSDictionary*)responseObject;
        
        NSString *res = [dict objectForKey: @"success"];
        
        if ([res isEqualToString: @"1"])
        {
            NSDictionary *data = [dict objectForKey: @"data"];
            NSLog(@"Message Receive status%@",data);
            if([[data objectForKey:@"pushmessage"] isEqualToString:@"1"])
            {
                //                PFQuery *query = [PFInstallation query];
                //                [query whereKey:@"owner" equalTo:chatPartner.mUserId];
                //
                //                PFPush *push = [[PFPush alloc] init];
                //                [push setQuery:query];
                //                //                NSString *lastMessage=[Engine base64Decode:[data objectForKey:@"last_message"]];
                //                NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                //                                       [NSString stringWithFormat:@"%@ sent you a new message",[Engine gPersonInfo].mUserName], @"alert",
                //                                       @"Increment", @"badge",
                //                                       @"7", @"notif_type",//Message
                //                                       [Engine gPersonInfo].mUserId,@"sender",
                //                                       nil];
                //                [push setData:data1];
                //                [push sendPushInBackground];
            }
            [self processReceivedMessages:data];
        }
        [Engine setGSrvTime: [dict objectForKey: @"current_time"]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        mIsPause = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [mActivityIndicator stopAnimating];
        mIsPause = NO;
    }];
    requestSent++;
    textView.text=@"";
}
#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}



#pragma mark - Table view data source



- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    return [mArrDate count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (UIView *)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *cellView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, mTView.frame.size.width, 34)];
    //    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(80, 10, 160, 24)];
    //    [imgView setImage: [UIImage imageNamed: @"chat_lbl_date.png"]];
    //    [cellView addSubview: imgView];
    UILabel *lblDate = [[UILabel alloc] initWithFrame: CGRectMake(90, 18, 140, 14)];
    JMessageInfo*message=[[mArrChatMsg objectAtIndex: section] objectAtIndex:0];
    
    NSTimeInterval epoch = [message.mTimeStamp doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    //    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"cn"]];
    
    //    [NSLocale currentLocale]
    //    [formatter setTimeStyle:NSDateFormatterLongStyle];
    //    [formatter setDateFormat: @"MM/dd/yyyy"];
    
    //    [lblDate setText: [NSString stringWithFormat:@"%@",date]];
    //    [lblDate setText: [mArrDate objectAtIndex: section]];
    [lblDate setText: [formatter stringFromDate:date]];
    
    //    [cell setInfo: [[mArrChatMsg objectAtIndex: indexPath.section] objectAtIndex: indexPath.row]];
    [lblDate setTextAlignment: NSTextAlignmentCenter];
    [lblDate setTextColor: [UIColor darkGrayColor]];
    [lblDate setFont:[UIFont systemFontOfSize:11.0]];
    
    [cellView addSubview: lblDate];
    
    return cellView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JMessageInfo *info = [[mArrChatMsg objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    int height = 0;
    height = [JChatTableCell cellHeightForMessage: info];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[mArrChatMsg objectAtIndex: section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMessageInfo* info=[[mArrChatMsg objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    JChatTableCell* cell;
    if ([info.mUserId isEqualToString:[Engine gPersonInfo].mUserId])
    {
        cell= [ tableView dequeueReusableCellWithIdentifier : @"JChatTableCell" ] ;
    }
    else
    {
        cell= [ tableView dequeueReusableCellWithIdentifier : @"JChatTableCell1" ] ;
        
    }
    
    if( cell == nil )
    {
        cell = [ JChatTableCell sharedCell];
        cell.delegate = self;
    }
    else
    {
//        NSLog(@"Already there");
    }
    [cell setInfo: [[mArrChatMsg objectAtIndex: indexPath.section] objectAtIndex: indexPath.row]];
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - User Functions

- (BOOL)isExistDate: (NSString *)dateStr
{
    for (int i = 0; i < [mArrDate count]; i++)
    {
        NSString *str = [mArrDate objectAtIndex: i];
        
        if ([str isEqualToString: dateStr])
        {
            return YES;
        }
    }
    
    return NO;
}


- (IBAction)onTouchBtnBack: (id)sender
{
    //    if(mTextMsg.isEditing)
    //    {
    //        [mTextMsg resignFirstResponder];
    //    }
    //    f(![mFullPhotoView isHidden])
    //    {
    //        [self closeFullPhotoView:nil];
    //        return;
    //    }
    [mViewForChat endEditing:YES];
    [Engine setIsBackAction:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onTouchBtnSend: (id)sender
{
    if(mImgButtonView.isHidden)
    {
        [mActivityIndicator startAnimating];
        [mBtnSend setEnabled:NO];

        [self sendMessage:MESSAGE_TYPE_NOTE];
    }
    else
    {
        [mActivityIndicator startAnimating];
        [mBtnSend setEnabled:NO];
        mIsPhotoUploading=YES;
        mBtnPhotoSend.enabled=NO;
        [self setMFileNameToUpload:[self fileKeyForUpload]];
        [self uploadProfilePhoto:mImgPreview.image quality:0.8];
        [mPhotoNotifMessage setText:@"Sending photo..."];
        
        //-----again---
        [self showPhotoNotification];
        //-------------
        
        mImgPreview.image=nil;
        [mImgButtonView setHidden:YES];
        textView.userInteractionEnabled=YES;
        textView.placeholder = @"Say something...";
    }
}
- (IBAction)onTouchBtnBlock:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Block this user" message: @"Are you sure you want to block this user? This action can not be undone." delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self sendRequestBlockUser];
    }
}
#pragma mark picture
- (IBAction)onTouchBtnCancelPicture:(id)sender {
    [mImgButtonView setHidden:YES];
    textView.userInteractionEnabled=YES;
    //    [textView setHidden:NO];
    textView.placeholder = @"Say something...";
    [mBtnSend setEnabled:NO];
}
- (NSString *)fileKeyForUpload
{
    int time_key=[[NSDate date] timeIntervalSince1970];//*1000;
    return [NSString stringWithFormat:@"%@_%d",[Engine gPersonInfo].mUserId,time_key];
}

- (void)uploadProfilePhoto:(UIImage*)imageTo quality:(float)quality
{
    NSLog(@"Profile Photo ID: %@",[self mFileNameToUpload]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^ {
        
        [self scaleAndRotateImage:imageTo];
        NSData *data = [NSData dataWithData: UIImageJPEGRepresentation([self mImageSmall],quality)];
        if (!data && !data.length)
            return;
        
        //        NSDictionary* parameters=[[NSDictionary alloc] initWithObjectsAndKeys:@"chat",@"type",@"send_message",@"cmd",[Engine gPersonInfo].mUserId, @"userid",[Engine gPersonInfo].mSessToken,@"sesstoken",chatPartner.mUserId,@"partner_id",[NSString stringWithFormat: @"%d", mPointer],@"pointer", MESSAGE_TYPE_NOTE,@"msgtype",[Engine base64Encode:trimmedString],@"msg", nil];//[Engine gPersonInfo].mLat
        
        NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
        [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
        [parameters setObject:@"chat" forKey:@"type"];
        [parameters setObject:@"send_message" forKey:@"cmd"];
        [parameters setObject:[NSString stringWithFormat:@"%@",MESSAGE_TYPE_PHOTO] forKey:@"msgtype"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)chatPartner.userid] forKey:@"partner_id"];
        [parameters setObject:[NSString stringWithFormat: @"%d", mPointer] forKey:@"pointer"];
        [parameters setObject:mFileNameToUpload forKey:@"photoname"];
        [parameters setObject:@"" forKey:@"msg"];
        
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:data name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
             
         } success:^(NSURLSessionDataTask *task, id responseObject)
         {
             
             NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
             NSString *res = [dict objectForKey: @"success"];
             
             if ([res isEqualToString: @"1"])
             {
                 NSDictionary *data = [dict objectForKey: @"data"];
                 NSString *error1 = [data objectForKey: @"error"];
                 NSString *title = [data objectForKey: @"title"];
                 NSString *message = [data objectForKey: @"message"];
                 if([error1 isEqualToString:@"1"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     [mActivityIndicator stopAnimating];
                     [self processReceivedMessages:data];
                     [mPhotoNotifMessage setText:@"Photo Sent"];
                     [self hidePhotoNotification];
                     
                 }
             }
             else
             {
                 [self showServiceUnavailableAlert];
             }
         }
              failure:nil];
    });
}

-(UIImage * )scaleAndRotateImage:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    
    if ( !image )
        NSLog(@"Image is nil in scaleAndRotateImage");
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    //	CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    //	[self setMImageBig:image];
    
    
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGContextRef context1 = CGBitmapContextCreate(NULL, PREFERED_WIDTH,PREFERED_HEIGHT, 8, PREFERED_WIDTH * 4, colorSpace1, kCGImageAlphaPremultipliedLast);
    //	CGContextTranslateCTM(context, 0, bounds.size.height);
    //	CGContextScaleCTM(context, 1, -1);
    CGColorSpaceRelease(colorSpace1);
    
    
    
    CGContextScaleCTM(context1, PREFERED_WIDTH/bounds.size.width, PREFERED_WIDTH/bounds.size.width);
    CGContextTranslateCTM(context1, 0, -(bounds.size.height-bounds.size.width)/2.0);
    //	CGContextConcatCTM(context, transform);
    CGContextDrawImage(context1, CGRectMake(0, 0, bounds.size.width, bounds.size.height), image.CGImage);
    CGImageRef imageRef1 = CGBitmapContextCreateImage(context1);
    UIImage *finalImage1 = [[UIImage alloc] initWithCGImage:imageRef1 scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef1);
    CGContextRelease(context1);
    
    //    mImageSmall=finalImage;
    [self setMImageBig:finalImage1];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, THUMBNAIL_WIDTH,THUMBNAIL_HEIGHT, 8, THUMBNAIL_WIDTH * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    //	CGContextTranslateCTM(context, 0, bounds.size.height);
    //	CGContextScaleCTM(context, 1, -1);
    CGColorSpaceRelease(colorSpace);
    CGContextScaleCTM(context, THUMBNAIL_WIDTH/bounds.size.width, THUMBNAIL_WIDTH/bounds.size.width);
    CGContextTranslateCTM(context, 0, -(bounds.size.height-bounds.size.width)/2.0);
    //	CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, bounds.size.width, bounds.size.height), image.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [[UIImage alloc] initWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    //    mImageSmall=finalImage;
    [self setMImageSmall:finalImage];
    return finalImage;
}
- (IBAction)onTouchSendPhoto:(id)sender
{
    
    JMyActionSheet* actionSheet = [ [ JMyActionSheet alloc ] initWithTitle : @"Add Photo"
                                                                  delegate : self
                                                         cancelButtonTitle : @"Cancel"
                                                    destructiveButtonTitle : @"Camera"
                                                         otherButtonTitles : @"From Photo Library", nil ] ;
    //    [actionSheet resignFirstResponder];
    //    isKeyboardHiding=YES;
    [ actionSheet showInView : mTView] ;
}

#pragma mark - Action Sheet
- (void)actionSheet: (UIActionSheet *) _actionSheet clickedButtonAtIndex : (NSInteger) _buttonIndex
{
    if([_actionSheet.title isEqualToString: @"Add Photo"])
    {
        UIImagePickerController* pickerController = nil;
        
        switch(_buttonIndex)
        {
            case 0: // Camera ;
                if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)
                {
                    return ;
                }
                //                isKeyboardHiding=YES;
                [mViewForChat endEditing:YES];
                pickerController = [[UIImagePickerController alloc] init];
                pickerController.delegate  = self;
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                pickerController.allowsEditing = YES;
                
                [self presentViewController: pickerController animated: YES completion: nil];
                [Engine setIsBackAction:YES];
                break ;
                
            case 1: // Photo ;
                //                isKeyboardHiding=YES;
                [mViewForChat endEditing:YES];
                pickerController = [[UIImagePickerController alloc] init];
                pickerController.delegate = self;
                pickerController.allowsEditing = YES;
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController: pickerController animated: YES completion: nil];
                [Engine setIsBackAction:YES];
                break ;
                
            default :
                //                cancelClicked=YES;
                break ;
        }
    }
}

#pragma mark - Image Picker
- (void)imagePickerController: (UIImagePickerController *) _picker didFinishPickingMediaWithInfo: (NSDictionary *) _info
{
    NSURL *mediaUrl = (NSURL *)[_info valueForKey: UIImagePickerControllerMediaURL];
    
    if(mediaUrl == nil)
    {
        UIImage* img=[_info valueForKey: UIImagePickerControllerEditedImage];
        mImgPreview.image=img;
        [mImgButtonView setHidden:NO];
        //        [textView setHidden:YES];
        [textView setText:@""];
        [textView refreshHeight];
        textView.userInteractionEnabled=NO;
        textView.placeholder = @"";
        [mBtnSend setEnabled:YES];
        [_picker dismissViewControllerAnimated : YES completion : ^{
        }];
    }
}
-(void)showServiceUnavailableAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Warning" message: @"Service unavailable" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark   ------ overlay -------
-(IBAction)onTouchBtnOverlay:(id)sender
{
    [self showOverlay];
    
}
-(void)showOverlay
{
    UIImageView *mOverlayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIView *mOverlayContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    mOverlayContainerView.tag = 199;
    
    self.view.layer.cornerRadius = 0;
    self.view.layer.masksToBounds = YES;
    mOverlayView.layer.masksToBounds=YES;
    [mOverlayView setContentMode:UIViewContentModeScaleAspectFill];
    UIImage * image = [UIImage imageNamed:@"chat_overlay.png"];
    mOverlayView.image = image;
    [mOverlayContainerView addSubview:mOverlayView];
    [self.view addSubview:mOverlayContainerView];
    
    UITapGestureRecognizer *mGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOverlayTap:)];
    mGesture.numberOfTouchesRequired=1;
    [mOverlayContainerView addGestureRecognizer:mGesture];
}
-(void)onOverlayTap:(UITapGestureRecognizer *)sender
{
    UIView *overlayView = [self.view viewWithTag:199];
    [overlayView setHidden:YES];
    [overlayView removeFromSuperview];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"chat_overlay_status"];
    [defaults synchronize];
}

@end
