//
//  JMatchedFriendTableViewCell.h
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface JMatchedFriendTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *mImgUserPhoto;
    IBOutlet UILabel *mLblUserName;
}
+(id) sharedCell;
-(void)setInfo:(Person *) person;
@end
