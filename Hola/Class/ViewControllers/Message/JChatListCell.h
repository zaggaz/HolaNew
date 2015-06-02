//
//  JCChatListCell.h
//  Hola
//
//  Created by Jin Wang.
//  Copyright (c) 2015 e. All rights reserved.
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
