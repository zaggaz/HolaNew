//
//  JFriendListViewController.h
//  Hola
//
//  Created by Jin Wang on 5/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFriendListViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *mTvUserList;
    IBOutlet UILabel *noMatchesLabel;

    int mPage;
}
@property(nonatomic, strong)NSMutableArray *mArrMatchList;
+ ( JFriendListViewController* ) sharedController;
@end
