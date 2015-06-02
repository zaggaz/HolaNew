//
//  JMatchViewController.m
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JMatchViewController.h"
#import "JChatViewController.h"
#import "JHomeDetailViewController.h"
@interface JMatchViewController ()

@end

@implementation JMatchViewController
@synthesize mCurrentPerson;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
+ ( JMatchViewController* ) sharedController
{
    __strong static JMatchViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JMatchViewController alloc ] initWithNibName : @"JMatchViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [mImgUserPhoto.layer setCornerRadius:mImgUserPhoto.frame.size.width / 2];
    [mImgUserPhoto.layer setMasksToBounds:YES];

    [mImgUserPhoto.layer setBorderWidth:3.0f];
    [mImgUserPhoto.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mImgUserPhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    [mImgMatchedUserPhoto.layer setCornerRadius:mImgMatchedUserPhoto.frame.size.width / 2];
    [mImgMatchedUserPhoto.layer setMasksToBounds:YES];

    [mImgMatchedUserPhoto.layer setBorderWidth:3.0f];
    [mImgMatchedUserPhoto.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [mBtnChat.layer setBorderWidth:1.0f];
    [mBtnChat.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnChat.layer setCornerRadius:5.0f];
    
    [mBtnTerminate.layer setBorderWidth:1.0f];
    [mBtnTerminate.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mBtnTerminate.layer setCornerRadius:5.0f];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if(mCurrentPerson)
    {
        [mImgMatchedUserPhoto setImageWithURL:[NSURL URLWithString:mCurrentPerson.photourl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
        [mLblDescription setText:[NSString stringWithFormat:@"%@ liked you too", mCurrentPerson.name]];
    }
}
-(IBAction)onTouchBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onTouchBtnChat:(id)sender
{
    [Engine setGCurrentMessageHistory:mCurrentPerson];
    [Engine setIsBackAction:NO];
    JChatViewController *pMatchView = [JChatViewController sharedController];
    [self.navigationController pushViewController:pMatchView animated:YES];
//  [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_CHAT_VIEW object: nil];
}
-(IBAction)onTouchBtnProfile:(id)sender
{
    JHomeDetailViewController *pHomeDetail = [JHomeDetailViewController sharedController];
    [pHomeDetail setMCurPerson:mCurrentPerson];
    
    [self.navigationController pushViewController:pHomeDetail animated:YES];
}
@end
