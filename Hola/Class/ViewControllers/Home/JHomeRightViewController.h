//
//  JHomeRightViewController.h
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHomeRightViewController : UIViewController
{
    IBOutlet UITableView *mTvUserList;
    int mPage;
    IBOutlet UILabel *noChatsLabel;

}



@property (nonatomic, retain) NSMutableArray          *mArrData;
@property (nonatomic, retain) NSMutableDictionary          *mDictData;
@property (nonatomic, retain) NSMutableArray        *mArrUserList;


+ ( JHomeRightViewController* ) sharedController;
@end
