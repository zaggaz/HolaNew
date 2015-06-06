//
//  JProfileViewController.h
//  Hola
//
//  Created by Jin Wang on 30/3/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"

@interface JProfileViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIView* mBgGrayView;
    
    IBOutlet UIScrollView *mScrollPhotoView;
    IBOutlet UIPageControl *mPageControl;
    
    IBOutlet UIButton *mBtnProfileEdit;
    IBOutlet UIButton *mBtnAddMainPhoto;
    IBOutlet UIView *mViewProfileContainer;
    IBOutlet UIActivityIndicatorView *mIndicatorProfileMainPhoto;
    
    IBOutlet UILabel *mLblUserName;
    IBOutlet UIImageView *mImgProfilePhotoEdit;
    
    
    IBOutlet UIScrollView *mScrollProfileEdit;
    IBOutlet UIView *mViewProfileEditContainer;
    IBOutlet UIButton *mBtnProfileEditDone;

    IBOutlet UIScrollView *mScrollEditUserOtherPhotos;
    IBOutlet UIView *mViewEditUserOtherPhotoContainer;
    IBOutlet UITextField *mTxtEditEmail;
    IBOutlet UITextField *mTxtEditBirthday;
    UIDatePicker *datePicker;
    
    IBOutlet UITextField *mTxtEditCity;
    IBOutlet UISegmentedControl *mSegEditGender;
    IBOutlet UITextView *mTxtAbout;
    IBOutlet UILabel *mLblOtherPhotoEditTitle;
    
    IBOutlet UIButton *mBtnAddMorePhoto;
    IBOutlet UIView* mDeletePhotoConfirmView;
    int deletePic;
    

    
    IBOutlet UIButton *mBtnShowSideLeftView;
    IBOutlet UIButton *mBtnShowSideRightView;
    IBOutlet UIButton *mBtnProceed;
    
    int photoType;
}
@property(nonatomic, strong) NSString* mPageType;
@property (nonatomic, strong) PMCalendarController *pmCC;
+ ( JProfileViewController* ) sharedController;
@end
