//
//  JFriendCellTableViewCell.m
//  Hola
//
//  Created by Jin Wang on 5/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JFriendCellTableViewCell.h"

@implementation JFriendCellTableViewCell

- (void)awakeFromNib {
    [mImgUserPhoto.layer setCornerRadius:mImgUserPhoto.frame.size.width / 2];
    [mImgUserPhoto.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

+(id) sharedCell
{
    JFriendCellTableViewCell* cell = [[[ NSBundle mainBundle ] loadNibNamed:@"JFriendCellTableViewCell" owner:nil options:nil] objectAtIndex:0] ;
    return cell ;
}
-(void)setInfo:(Person *) person
{
    //[mImgUserPhoto setImage:person.image];
    [mImgUserPhoto setImageWithURL:[NSURL URLWithString:person.photourl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    mLblUserName.text = [NSString stringWithFormat:@"%@ • %lu",person.name,(unsigned long)person.age];
    
    NSDate *myDate ;
    NSString *mPrefix = @"matched on";
    if([person.mLastMsgDate integerValue] > 0)
    {
        mPrefix = @"";
        myDate = [[NSDate alloc]initWithTimeIntervalSince1970:[person.mLastMsgDate integerValue]];
        mLblMsg.text = person.mLastMsg;
    }
    else myDate = [[NSDate alloc]initWithTimeIntervalSince1970:person.mSettime];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YY hh:mm"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    [mLblTime setText: [NSString stringWithFormat:@"%@ %@",mPrefix,prettyVersion]];
    
    
}

@end
