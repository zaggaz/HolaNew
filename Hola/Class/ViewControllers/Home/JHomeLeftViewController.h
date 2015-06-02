//
//  JHomeLeftViewController.h
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHomeLeftViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *mImgUserProfilePhoto;
    IBOutlet UILabel *mLblUserName;
    NSMutableArray *arrOfOptions;
}
+ ( JHomeLeftViewController* ) sharedController;
@property(nonatomic, weak) IBOutlet UITableViewCell *cellMain;

@end
