//
//  JHomeDetailViewController.h
//  Hola
//
//  Created by Jin Wang on 3/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHomeDetailViewController : UIViewController
{
    IBOutlet UIScrollView *mScrollMainView;
    IBOutlet UIScrollView *mScrollPhotoView;
    IBOutlet UIPageControl *mPagePhoto;
    IBOutlet UIView *mViewPhotoContainer;
    
    IBOutlet UIView *mViewUserDescriptionView;
    IBOutlet UILabel *mLblUserDescription;
    IBOutlet UILabel *mLblUserName;
}
+ ( JHomeDetailViewController* ) sharedController;

@property(nonatomic, strong)NSString *mUserId;
@property(nonatomic, strong)NSString *mPrevUserId;
@property(nonatomic, strong)Person * mCurPerson;
@property(nonatomic, strong)NSMutableArray *mArrUserPhotos;

@end
