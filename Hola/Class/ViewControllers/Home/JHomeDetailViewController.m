//
//  JHomeDetailViewController.m
//  Hola
//
//  Created by Jin Wang on 3/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JHomeDetailViewController.h"

@interface JHomeDetailViewController ()

@end

@implementation JHomeDetailViewController
@synthesize mArrUserPhotos;
@synthesize mCurPerson;
@synthesize mUserId;
@synthesize mPrevUserId;


+ ( JHomeDetailViewController* ) sharedController
{
    __strong static JHomeDetailViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JHomeDetailViewController alloc ] initWithNibName : @"JHomeDetailViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [mViewPhotoContainer.layer setBorderWidth:1.0f];
    [mViewPhotoContainer.layer setBorderColor:[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1].CGColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [MBProgressHUD hideHUDForView:mScrollMainView animated:YES];
    if(![mPrevUserId isEqualToString:mUserId])
    {
        [mScrollPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [mArrUserPhotos removeAllObjects];

        
        mPagePhoto.currentPage = 0;
        [mScrollPhotoView setContentOffset:CGPointMake(0, 0)];
        

        mLblUserName.text = [NSString stringWithFormat:@"About %@",mCurPerson.name];
        NSData *decodedAboutData = [mCurPerson.description dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *decodedAbout = [[NSString alloc] initWithData:decodedAboutData encoding:NSNonLossyASCIIStringEncoding];
        mLblUserDescription.text = decodedAbout;
        [self getUserDetail];
        
        if(mCurPerson)
        {
            UIImageView *pImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScrollPhotoView.frame.size.width, mScrollPhotoView.frame.size.height)];
            [pImage setImageWithURL:[NSURL URLWithString:mCurPerson.photourl]];
            [mScrollPhotoView insertSubview:pImage aboveSubview:mPagePhoto];
            pImage.autoresizingMask = UIViewAutoresizingFlexibleHeight |   UIViewAutoresizingFlexibleWidth |     UIViewAutoresizingFlexibleBottomMargin;
            [pImage setContentMode:UIViewContentModeScaleAspectFill];
            [self displayUserDetail];
        }
        mPrevUserId = mUserId;
    }
    else {
        
    }

}
-(void)displayUserDetail
{
    NSData *decodedAboutData = [mCurPerson.description dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *decodedAbout= [[NSString alloc] initWithData:decodedAboutData encoding:NSNonLossyASCIIStringEncoding];
    mLblUserDescription.text = decodedAbout;
    CGSize cz = [AppEngine messageSize:mCurPerson.description font:mLblUserDescription.font width:mLblUserDescription.frame.size.width];
    
    
    int nDescriptionLblOriginalHeight = mLblUserDescription.frame.size.height;
    int nDescriptionViewOriginalHeight = mViewUserDescriptionView.frame.size.height;
    [mLblUserDescription setFrame:CGRectMake(mLblUserDescription.frame.origin.x, mLblUserDescription.frame.origin.y, mLblUserDescription.frame.size.width, cz.height)];
    
    //[self getAddressFromLatLon:[mCurPerson.latitude floatValue] withLongitude:[mCurPerson.longitude floatValue]];
    
    [mViewUserDescriptionView setFrame:CGRectMake(mViewUserDescriptionView.frame.origin.x
                                                  , mViewUserDescriptionView.frame.origin.y, mViewUserDescriptionView.frame.size.width, mViewUserDescriptionView.frame.size.height +     mLblUserDescription.frame.size.height - nDescriptionLblOriginalHeight)];
    [mScrollMainView setContentSize:CGSizeMake(mScrollMainView.frame.size.width, mScrollMainView.frame.size.height + mViewUserDescriptionView.frame.size.height - nDescriptionViewOriginalHeight)];
}
-(void)getUserDetail
{
    
    if(!mUserId || !mUserId.length)
        return;
    [MBProgressHUD showHUDAddedTo:mScrollMainView animated:YES];
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"uId"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:mUserId forKey:@"person_id"];
    [parameters setObject:@"dating" forKey:@"type"];
    [parameters setObject:@"get_user_detail" forKey:@"cmd"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        if ([res isEqualToString: @"1"])
        {
            [MBProgressHUD hideHUDForView:mScrollMainView animated:YES];
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                if([[data objectForKey:@"error"] isEqualToString:@"0"])
                {
                    NSDictionary *pDict = [data objectForKey:@"user"];
                    NSArray *photos = [data objectForKey:@"photos"];
                    if(!mCurPerson)
                        mCurPerson = [[Person alloc]setDataWithDictionary:pDict];
                    mPagePhoto.numberOfPages=(int)[photos count] + 1;
                    mArrUserPhotos = [photos mutableCopy];
                    [mArrUserPhotos insertObject:[pDict objectForKey:@"photourl"] atIndex:0];
                    [self initUserPhotos];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }
            }
        }
        else
        {
            [MBProgressHUD hideHUDForView:mScrollMainView animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        [MBProgressHUD hideHUDForView:mScrollMainView animated:YES];
        
    }];
    
}
-(void)initUserPhotos
{
    [mScrollPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    [mScrollPhotoView setContentOffset:CGPointMake(mScrollPhotoView.frame.size.width*mPagePhoto.currentPage, 0) animated:YES];
    [mScrollPhotoView setContentSize:CGSizeMake(mScrollPhotoView.frame.size.width * [mArrUserPhotos count], mScrollPhotoView.frame.size.height)];
    //NSLog(@"user %@ photo count %d",@"s", (int)[mArrUserPhotos count]);
    for(int i=0;i<[mArrUserPhotos count];i++)
    {
        UIImageView *pImage=[[UIImageView alloc] initWithFrame:CGRectMake(mScrollPhotoView.frame.size.width*i, 0, mScrollPhotoView.frame.size.width, mScrollPhotoView.frame.size.height)];
        pImage.layer.masksToBounds=YES;
        
        UILabel *mLbl=[[UILabel alloc] initWithFrame:pImage.frame];
        mLbl.text=@"Loading...";
        mLbl.textAlignment=NSTextAlignmentCenter;
        mLbl.textColor=[UIColor grayColor];
        [mScrollPhotoView addSubview: mLbl];
        [mScrollPhotoView insertSubview:pImage aboveSubview:mPagePhoto];
        NSString * strPhotoUrl = [mArrUserPhotos objectAtIndex:i];
        if([[strPhotoUrl substringToIndex:4] isEqualToString:@"http"])
            strPhotoUrl = strPhotoUrl;
        else
            strPhotoUrl = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",strPhotoUrl];
        
        [pImage setImageWithURL:[NSURL URLWithString:strPhotoUrl]];
        pImage.autoresizingMask = UIViewAutoresizingFlexibleHeight |   UIViewAutoresizingFlexibleWidth |     UIViewAutoresizingFlexibleBottomMargin;
        [pImage setContentMode:UIViewContentModeScaleAspectFill];
    }
}


-(IBAction)onTouchBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onTouchChangePage:(id)sender
{
   [mScrollPhotoView setContentOffset:CGPointMake(mScrollPhotoView.frame.size.width*mPagePhoto.currentPage, 0) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int mNewPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    if(scrollView==mScrollPhotoView)
    {
        if(mPagePhoto.currentPage!=mNewPage)
        {
            mPagePhoto.currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
        }
    }
    
    NSLog(@"scrollViewDidEndDecelerating: %f",scrollView.contentOffset.x);
}

@end
