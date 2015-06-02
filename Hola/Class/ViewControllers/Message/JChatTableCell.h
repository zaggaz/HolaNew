#import <UIKit/UIKit.h>

@class JMessageInfo;

@protocol JChatTableCellDelegate

@optional;
-(void) showFullPhoto: (JMessageInfo *) feedInfo;
@end


@interface JChatTableCell : UITableViewCell {
    JMessageInfo *_mCInfo;
//    IBOutlet UILabel *mLblTime;
    IBOutlet UILabel *mLblMessage;
//    IBOutlet UILabel *mLblSender;
    IBOutlet UIImageView *mImgSharedPhoto;
    IBOutlet UIView *mMessageView;
    IBOutlet UIImageView *mImgMessageBg;

    IBOutlet UIImageView    *mPhotoView;
//    IBOutlet UIImageView    *mImgMe;
}

@property (nonatomic, retain) JMessageInfo *mCInfo;

@property (nonatomic, assign) id<JChatTableCellDelegate>   delegate;

+ (CGFloat)cellHeightForMessage:(JMessageInfo *)message;

+(id) sharedCell;

- (void)setInfo: (JMessageInfo *)info;

@end
