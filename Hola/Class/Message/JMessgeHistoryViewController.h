//
//  JMessgeHistoryViewController.h
//  ThisIsWhere
//
//  Created by Jing on 3/31/14.
//  Copyright (c) 2014 Jing Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatListCell.h"
#import "Person.h"

@class MBProgressHUD;
@class JMenuView;

@interface JMessgeHistoryViewController : UIViewController<SWTableViewCellDelegate>
{
    MBProgressHUD           *mProgress;
    
    IBOutlet UITableView    *mTView;
    int                     mPage;
    NSMutableArray          *mArrData;
    NSMutableDictionary          *mDictData;
    
//    JMenuView               *mMenuView;

    

    
    Person*    actionToTaken;
}

@property (nonatomic, retain) NSMutableArray          *mArrData;
@property (nonatomic, retain) NSMutableDictionary          *mDictData;

+ ( JMessgeHistoryViewController* ) sharedController;

-(void) reloadMessageHistory;
@end
