//
//  JCChatListCell.h
//  HeavenlySinful
//
//  Created by Chen Jing on 11/22/13.
//  Copyright (c) 2013 Hector Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface JChatListCell : SWTableViewCell
{
    IBOutlet UILabel        *mLblName;
    IBOutlet UILabel        *mLblLastMsg;
//    IBOutlet UIView        *mLblNewMsgView;
//    IBOutlet UILabel        *mLblNewMsgNum;
    IBOutlet UILabel        *mLblTime;
    
    IBOutlet UIImageView    *mPhoto;
//    IBOutlet UIImageView    *mImgMadeup;
//    IBOutlet UIView         *mImgDot;
    JMessageHistoryInfo      *_mCInfo;


    IBOutlet UIView     *mBadgeView;
    IBOutlet UILabel     *mBadgeCount;
}

@property (nonatomic, retain) JMessageHistoryInfo          *mCInfo;

+(id) sharedCell;
- (void)setInfo: (JMessageHistoryInfo *)info;
@end
