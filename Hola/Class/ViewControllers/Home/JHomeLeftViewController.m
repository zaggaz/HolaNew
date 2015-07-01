//
//  JHomeLeftViewController.m
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JHomeLeftViewController.h"

@interface JHomeLeftViewController ()

@end

@implementation JHomeLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    NSLog(@"user photo %@", [NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl]);
    
    
    [mImgUserProfilePhoto.layer setCornerRadius:mImgUserProfilePhoto.frame.size.width / 2];
    [mImgUserProfilePhoto.layer setMasksToBounds:YES];
    [mImgUserProfilePhoto.layer setBorderWidth:3.0f];
    [mImgUserProfilePhoto.layer setBorderColor:[UIColor colorWithRed:251 green:107 blue:97 alpha:1].CGColor];
    
    
    arrOfOptions = [[NSMutableArray alloc]init];
    
    [self addTitle:@"Hola" imageName:@"icon-sidemenu-home.png" segueName:SHOW_MAIN_HOME];
//    [self addTitle:@"搜索" imageName:@"icon-sidemenu-location.png" segueName:SHOW_LOCATION];
    [self addTitle:@"Matches" imageName:@"icon-sidemenu-chat.png" segueName:SHOW_FRIEND_LIST_VIEW];
//  [self addTitle:@"简介" imageName:@"btnIconProfile.png" segueName:SHOW_PROFILE];
    [self addTitle:@"Settings" imageName:@"icon-sidemenu-setting.png" segueName:SHOW_SETTING_VIEW];

    UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBtnUserProfile:)];
    recognizer.numberOfTouchesRequired=1;
    recognizer.delegate=self;
    [mImgUserProfilePhoto setUserInteractionEnabled:YES];
    [mImgUserProfilePhoto addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(profilePicChanged:) name: PROFILE_PICTURE_CHANGED object: nil];
}

-(void) profilePicChanged:(id)sender {
    [mImgUserProfilePhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mImgUserProfilePhoto setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    [mLblUserName setText:[Engine gPersonInfo].mUserName];
}
-(void)onTouchBtnUserProfile:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_PROFILE object:nil];
}
-(void)addTitle:(NSString *)title imageName:(NSString *)imageName segueName:(NSString *)segue
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:title forKey:@"title"];
    [dic setObject:imageName forKey:@"image"];
    [dic setObject:segue forKey:@"segue"];
    [arrOfOptions addObject:dic];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ ( JHomeLeftViewController* ) sharedController
{
    __strong static JHomeLeftViewController* sharedController = nil ;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JHomeLeftViewController alloc ] initWithNibName : @"JHomeLeftViewController" bundle : nil ] ;
    } ) ;
    return sharedController;
}

#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return arrOfOptions.count;
    //return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellMainNibID = @"MainCellLeft";
    
    _cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    if (_cellMain == nil) {
        _cellMain= [[[ NSBundle mainBundle ] loadNibNamed:@"MainCellLeft" owner:nil options:nil] objectAtIndex:0];
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:251/255.0f green:107/255.0f blue:97/255.0f alpha:1];
        [_cellMain setSelectedBackgroundView:bgColorView];
    }
    NSMutableDictionary *menuItem = [arrOfOptions objectAtIndex:indexPath.row];
    
    UIImageView *mainImage = (UIImageView *)[_cellMain viewWithTag:1];
    UILabel *imageTitle = (UILabel *)[_cellMain viewWithTag:2];
    imageTitle.text = [menuItem objectForKey:@"title"];
    mainImage.image = [UIImage imageNamed:[menuItem objectForKey:@"image"]];
    return _cellMain;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *menuItem = [arrOfOptions objectAtIndex:indexPath.row];    
    [[NSNotificationCenter defaultCenter]postNotificationName:[menuItem objectForKey:@"segue"] object:nil];
}
- (IBAction)onTouchPrivacy:(id)sender {
}


@end
