//
//  JMatchViewController.h
//  Hola
//
//  Created by Jin Wang on 6/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMatchViewController : UIViewController
{
    IBOutlet UIImageView *mImgUserPhoto;
    IBOutlet UIImageView *mImgMatchedUserPhoto;
    IBOutlet UIButton *mBtnChat;
    IBOutlet UIButton *mBtnTerminate;
    
    IBOutlet UILabel *mLblDescription;
}
@property(nonatomic, strong)Person *mCurrentPerson;

+ ( JMatchViewController* ) sharedController;
@end
