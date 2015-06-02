//
//  JFriendCellTableViewCell.h
//  Hola
//
//  Created by Jin Wang on 5/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface JFriendCellTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *mImgUserPhoto;
    IBOutlet UILabel *mLblUserName;
    IBOutlet UILabel *mLblTime;
    IBOutlet UILabel *mLblMsg;
}

+(id) sharedCell;
-(void)setInfo:(Person *) person;

@end
