

#import "JChatTableCell.h"
#import "Constants.h"
#import "AppEngine.h"
//#import "JAmazonS3ClientManager.h"
#import <CoreText/CoreText.h>

#define PLACEHOLDERIMAGE [UIImage imageNamed:@"icon_userplaceholder.png"]
#define MESSAGEFONT [UIFont fontWithName:@"Lato-Regular" size:14]
#define MESSAGEBOUNDARY CGSizeMake(205, 0)
#define ADDITIONAL_HEIGHT 35


@implementation JChatTableCell

@synthesize mCInfo = _mCInfo;
@synthesize delegate;
+(id) sharedCell
{
    JChatTableCell* cell = [[[ NSBundle mainBundle ] loadNibNamed:@"JChatTableCell" owner:nil options:nil] objectAtIndex:0] ;
    
    return cell ;
}
-(NSString*)reuseIdentifier{
    return @"JChatTableCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(CGSize)messageSize:(NSString*)message font:(UIFont*)font
{
    
//    return [message sizeWithFont:font constrainedToSize:MESSAGEBOUNDARY lineBreakMode:
//           NSLineBreakByWordWrapping];
    //[UIFont systemFontOfSize:14][UIFont fontWithName:@"Helvetica Neue" size:14]

    return [message boundingRectWithSize:MESSAGEBOUNDARY options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;

//    return [message sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
}

-(CGSize)messageSize:(NSString*)message {
    
    return [message sizeWithFont:MESSAGEFONT constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:
            NSLineBreakByCharWrapping];
}




- (void)setInfo:(JMessageInfo *)info
{
    [self setMCInfo:info];
//    return;
    mImgSharedPhoto.image = nil;
    mImgMessageBg.image=nil;
    mPhotoView.image=nil;
    mPhotoView.layer.cornerRadius=20;
    mPhotoView.layer.masksToBounds=YES;
    if (info == nil) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [mLblTime setText:
     [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970:
       [[info mTimeStamp] doubleValue]]]];
    
    // if sender is me
    if([info.mMsgType isEqualToString:MESSAGE_TYPE_NOTE])
    {
        info.mMsg = [info.mMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [mImgMessageBg setHidden:NO];
        [mLblMessage setHidden:NO];
        [mImgSharedPhoto setHidden:YES];
        float yOffset=7;
        float xOffset=15;
        float fontSize = 14;
        CGSize textSize=[self messageSize:info.mMsg font:MESSAGEFONT];
        if(textSize.width>205)
            textSize.width=205;
        mLblMessage.frame = CGRectMake(xOffset, yOffset, textSize.width,textSize.height);
        [mLblMessage setText:[info mMsg]];
     
        if ([info.mUserId isEqualToString:[Engine gPersonInfo].mUserId]){
            mLblTime.frame = CGRectMake(textSize.width - 5, yOffset + textSize.height + 7, 60, 14);
            mMessageView.frame = CGRectMake(242-textSize.width, 5, textSize.width+(xOffset*2),textSize.height + (yOffset*2) + fontSize + 5);

        }else {
            mMessageView.frame = CGRectMake(45, 5, textSize.width+(xOffset*2),textSize.height + (yOffset*2) + fontSize + 5);
            mLblTime.frame = CGRectMake(5, yOffset + textSize.height + 7, 60, 14);

        }
    }else {
        [mImgSharedPhoto setImageWithURL:[NSURL URLWithString:info.mFileUrl] placeholderImage:[UIImage imageNamed:@"bgLightGray.png"]];
        [mLblMessage setHidden:YES];
        [mImgMessageBg setHidden:YES];
        mImgSharedPhoto.frame=CGRectMake(5,5,200,200);
        [mImgSharedPhoto.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
        [mImgSharedPhoto.layer setBorderWidth:0.5];
        [mImgSharedPhoto setHidden:NO];
        mImgSharedPhoto.layer.masksToBounds=YES;
        
        [mImgSharedPhoto.layer setCornerRadius:10];
        if ([info.mUserId isEqualToString:[Engine gPersonInfo].mUserId]){
            mMessageView.frame = CGRectMake(62, 20, 210,230);
            mLblTime.frame = CGRectMake(175, 207, 60, 14);
        }else {
            mMessageView.frame = CGRectMake(45, 20, 210,230);
            mLblTime.frame = CGRectMake(5, 207, 60, 14);
        }
    }
    
    NSString *imgUrl;
    if ([info.mUserId isEqualToString:[Engine gPersonInfo].mUserId])
    {
        mImgMessageBg.image = [[UIImage imageNamed:@"bubbleRight2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 18, 25)];
        mPhotoView.frame = CGRectMake(272, mMessageView.frame.size.height-35, 40, 40);
        imgUrl = [Engine gPersonInfo].mPhotoUrl;
    }else {
        mImgMessageBg.image = [[UIImage imageNamed:@"bubbleLeft2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 18, 20)];
        mPhotoView.frame = CGRectMake(5.0, mMessageView.frame.size.height-35, 40, 40);
        imgUrl = [Engine gCurrentMessageHistory].photourl;

    }
    [mPhotoView setContentMode:UIViewContentModeScaleAspectFill];
    [mPhotoView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];

}
-(void)onTouchBtnAction:(id)sender
{
//    JCChatViewController* chatView=[JCChatViewController sharedController];
//    [chatView showFullImage:[[JCAmazonS3ClientManager defaultManager] cdnUrlForChatPhoto:[self.message mMsg]]];
    if ([(id)delegate respondsToSelector: @selector(showFullPhoto:)])
    {
        [delegate showFullPhoto:[self mCInfo]];
    }
}




+ (CGFloat)heightStringWithEmojis:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width{
    
    // Get text
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef) str );
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
    
    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);
    
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    
    return frameSize.height + 5;
}

+ (CGFloat)cellHeightForMessage:(JMessageInfo *)message
{
    CGFloat height=0.0;

    if([message.mMsgType isEqualToString:MESSAGE_TYPE_NOTE])
    {
        height=ADDITIONAL_HEIGHT;
        height+=[message.mMsg boundingRectWithSize:MESSAGEBOUNDARY options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MESSAGEFONT} context:nil].size.height+5;
    }
    else
    {
        height=240;
        
    }
    return height;
}

@end
