//
//  JCChatListCell.m
//  Hola
//
//  Created by Jin Wang.
//  Copyright (c) 2015 e. All rights reserved.
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

    [mPhoto setImageWithURL:[NSURL URLWithString:info.mPhoto] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    if((info.mNewMsgNum)&&([info.mNewMsgNum isEqualToString:@"0"]))
    {
        [mBadgeView setHidden:YES];
    }
    else
    {
        [mBadgeView setHidden:NO];
        [mBadgeCount setText:info.mNewMsgNum];
    }

    [mLblName setText: info.mFullName];

    
    [mLblLastMsg setText:info.mLastMsg];
    

//    NSDate *mDateToday = [NSDate date];
//    int nDelay = [mDateToday timeIntervalSince1970];
//    nDelay = nDelay - [info.mLastMsgDate intValue];


    NSDate *myDate =     [[NSDate alloc]initWithTimeIntervalSince1970:[info.mLastMsgDate intValue]];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd HH:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
        [mLblTime setText:prettyVersion];

    
    //[mLblTime setText:[NSString dateTimeStringFromTimestap:info.mLastMsgDate]];
}

+ (CGFloat)cellHeightForMessage:(Person *)message
{
    CGFloat height=0.0;
    
    height=[message.mLastMsg sizeWithFont:[UIFont fontWithName:@"lato" size:14] constrainedToSize:CGSizeMake(170, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height+ADDITIONAL_HEIGHT;
    return MAX(height, 71.0f);
}


@end
