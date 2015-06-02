//
//  JChatViewController.h
//  heyGreek
//
//  Created by Wang Bing on 21/4/15.
//  Copyright (c) 2015 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "HPGrowingTextView.h"
#import "JChatTableCell.h"


@interface JChatViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,JChatTableCellDelegate,UIGestureRecognizerDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate,UITextViewDelegate>

{

    Person *chatPartner;
    
    IBOutlet UIView *mViewForChat;
    IBOutlet UILabel *mLblUserName;
    
    
    IBOutlet UIImageView* mFullPhoto;
    IBOutlet UIView*        mFullPhotoView;
    IBOutlet UITableView    *mTView;
    
    
    IBOutlet UILabel *mUnreadMsgCount;
    
    //   Showing Meme Part
    
    
    int      creditsForMessage;
    UIImage *mImageBig;
    UIImage *mImageSmall;
    
    IBOutlet UIButton   *mBtnSend;
    
    UIActivityIndicatorView *mActivityIndicator;
    IBOutlet UIImageView *mBlankFrame;
    
    NSMutableArray          *mArrDate;
    NSMutableArray          *mArrChatMsg;
    
    BOOL                    mIsRunning;
    BOOL                    mIsPause;
    
    BOOL                    mIsPhotoUploading;
    
    int                     mPointer;
    UIImageView                 *mImgAnnot;
    int                 mLastTimestamp;
    int             first_message;
    NSString*                 mLastMessageId;
    
    NSString* mFileNameToUpload;
    
    //Text Field View
    HPGrowingTextView *textView;
    
    IBOutlet UIView *mPhotoNotification;
    IBOutlet UILabel *mPhotoNotifMessage;
    
    IBOutlet UIView *mImgButtonView;
    IBOutlet UIImageView *mImgPreview;
    IBOutlet UIButton *mBtnPhotoSend;
    
    IBOutlet UILabel *mLblChatPartner;
    int current_Run;
    int requestSent;
    //    IBOutlet UIButton   *mBtnSend;
    
    UIButton            *mBtnSelected;
}
+ ( JChatViewController* ) sharedController;
@property (nonatomic,retain)  NSString  *mFileNameToUpload;

@property (nonatomic, retain) UIImage *mImageBig;
@property (nonatomic, retain) UIImage *mImageSmall;
-(UIImage * )scaleAndRotateImage:(UIImage *)image;

@end
