//
//  JMatchedFriendTableViewCell.m
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JMatchedFriendTableViewCell.h"

@implementation JMatchedFriendTableViewCell

- (void)awakeFromNib {
    [mImgUserPhoto.layer setCornerRadius:mImgUserPhoto.frame.size.width / 2];
    [mImgUserPhoto.layer setBorderWidth:1.0f];
    [mImgUserPhoto.layer setMasksToBounds:YES];
    [mImgUserPhoto.layer setBorderColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.0].CGColor];
}
+(id) sharedCell
{
    JMatchedFriendTableViewCell* cell = [[[ NSBundle mainBundle ] loadNibNamed:@"JMatchedFriendTableViewCell" owner:nil options:nil] objectAtIndex:0] ;
    return cell ;
}
-(void)setInfo:(Person *) person
{
//    [mImgUserPhoto setImage:person.image];
    [mImgUserPhoto setImageWithURL:[NSURL URLWithString:person.photourl]];
    mLblUserName.text = [NSString stringWithFormat:@"%@ • %lu",person.name,(unsigned long)person.age];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
