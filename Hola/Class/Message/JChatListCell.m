//
//  JCChatListCell.m
//  HeavenlySinful
//
//  Created by Chen Jing on 11/22/13.
//  Copyright (c) 2013 Hector Mobile. All rights reserved.
//

#import "JChatListCell.h"
#import "Constants.h"
#import "AppEngine.h"
#import "NSString+J.h"
//#import "JAmazonS3ClientManager.h"
#define ADDITIONAL_HEIGHT 45

@implementation JChatListCell
@synthesize mCInfo = _mCInfo;

+(id) sharedCell
{
    JChatListCell* cell = [[[ NSBundle mainBundle ] loadNibNamed:@"JChatListCell" owner:nil options:nil] objectAtIndex:0] ;
    
    return cell ;
}
-(NSString*)reuseIdentifier{
    return @"JChatListCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo: (JMessageHistoryInfo *)info
{
    [self setMCInfo: info];
    
    [mPhoto.layer setCornerRadius:25];
    mPhoto.layer.masksToBounds=YES;
    mPhoto.image=nil;

    [mPhoto setImageWithURL:[NSURL URLWithString:info.mPhoto] placeholderImage:[UIImage imageNamed:@"profileplaceholder.png"]];
    if((info.mNewMsgNum)&&([info.mNewMsgNum isEqualToString:@"0"]))
    {
        [mBadgeView setHidden:YES];
    }
    else
    {
        [mBadgeView setHidden:NO];
        [mBadgeCount setText:info.mNewMsgNum];
    }
    
//    mPhoto.image=nil;
//    [mPhoto setImageWithURL:[[JAmazonS3ClientManager defaultManager] cdnUrlForPostPhotoThumb:info.mPost.mPhoto]];
    [mLblName setText: info.mFullName];
    
//    if([[Engine gPersonInfo].mUserId isEqualToString:info.mPost.mUserId])
//    {
//        [mLblName setText:info.mMadeupName];
//        [mImgMadeup setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",info.mMadeupName]]];
//    }
//    else
//    {
//        [mLblName setText:@"Author"];
//        [mImgMadeup setImage:[UIImage imageNamed:@"Author.png"]];
//    }
    
    [mLblLastMsg setText:info.mLastMsg];
    
    
//    float xpos=[mLblName.text sizeWithFont:[UIFont fontWithName:@"helvetica" size:14] constrainedToSize:CGSizeMake(320, 21) lineBreakMode:NSLineBreakByWordWrapping].width;
//    float xpos=[mLblName.text sizeWithFont:[UIFont fontWithName:@"helvetica" size:14] constrainedToSize:CGSizeMake(320, 21) lineBreakMode:NSLineBreakByWordWrapping].width;
//    [mLblName setFrame:CGRectMake(mLblName.frame.origin.x, mLblName.frame.origin.y, mLblName.frame.size.width, mLblName.frame.size.height)];
//    [mImgDot setFrame:CGRectMake(xpos+mLblName.frame.origin.x+10, mImgDot.frame.origin.y, 2, 2)];
//    [mLblTime setFrame:CGRectMake(xpos+mLblName.frame.origin.x+22, mLblTime.frame.origin.y, mLblTime.frame.size.width, mLblTime.frame.size.height)];

//    if([info.mNewMsgNum isEqualToString:@"0"] || [info.mNewMsgNum isEqualToString:@""])
//    {
//        [mLblNewMsgView setHidden:YES];
////        [mLblNewMsgView.layer.cornerRadius
//    }
//    else
//    {
//        [mLblNewMsgView setHidden:NO];
//        [mLblNewMsgNum setText:info.mNewMsgNum];
//    }
    
    [mLblTime setText:[NSString dateTimeStringFromTimestap:info.mLastMsgDate]];
}

+ (CGFloat)cellHeightForMessage:(Person *)message
{
    CGFloat height=0.0;
    
    height=[message.mLastMsg sizeWithFont:[UIFont fontWithName:@"helvetica" size:13] constrainedToSize:CGSizeMake(170, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height+ADDITIONAL_HEIGHT;
    return MAX(height, 71.0f);
}


@end
