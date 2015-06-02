//
//  JHomeViewController.m
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JSearchViewController.h"

@interface JSearchViewController ()

@end

@implementation JSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer* recognizer;
    recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground:)];
    recognizer.numberOfTouchesRequired=1;
    recognizer.delegate=self;
    [self.view addGestureRecognizer:recognizer];
    
    [mImgUserPhoto.layer setCornerRadius:mImgUserPhoto.frame.size.width / 2];
    [mImgUserPhoto.layer setMasksToBounds:YES];
    [mImgUserPhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ ( JSearchViewController* ) sharedController
{
    __strong static JSearchViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JSearchViewController alloc ] initWithNibName : @"JSearchViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}
-(IBAction)onTouchBtnLeftMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
}
-(IBAction)onTouchBtnRightMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_RIGHTBTN_TOUCH object: nil];
}
-(void)onTapBackground:(id)sender
{
    
}
@end
