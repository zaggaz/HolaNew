

#import "JChatTableCell.h"
#import "Constants.h"
#import "AppEngine.h"
//#import "JAmazonS3ClientManager.h"
#import <CoreText/CoreText.h>

#define PLACEHOLDERIMAGE [UIImage imageNamed:@"icon_userplaceholder.png"]
#define ASL_FONT [UIFont fontWithName:@"Gallaudet" size:48]
#define MESSAGEFONT_ITALIC [UIFont fontWithName:@"Arial-ItalicMT" size:14]
#define MESSAGEFONT [UIFont fontWithName:@"Lato-Regular" size:14]
#define MESSAGEBOUNDARY CGSizeMake(0, 0)
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
}

-(CGSize)messageSize:(NSString*)message {
    
    return [message sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:
            NSLineBreakByWordWrapping];//[UIFont systemFontOfSize:14][UIFont fontWithName:@"Helvetica Neue" size:14]
    //    return [message boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
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
    // if sender is me
    
    if ([info.mUserId isEqualToString:[Engine gPersonInfo].mUserId])
    {
        if([info.mMsgType isEqualToString:MESSAGE_TYPE_NOTE])
        {
            [mImgMessageBg setHidden:NO];
            float offset=10.0;
            float width=0;
            CGSize textSize=[self messageSize:info.mMsg font:[UIFont systemFontOfSize:16]];
            textSize.width+=5;
            if(textSize.width>205)
                textSize.width=205;
            mLblMessage.frame = CGRectMake(15, offset, textSize.width+2,textSize.height+5);
            width=textSize.width;
            offset+=textSize.height;
            [mLblMessage setHidden:NO];
            
            mMessageView.frame = CGRectMake(282-width-40, 5, width+30,offset+25);
            [mImgSharedPhoto setHidden:YES];
            [mLblMessage setText:[info mMsg]];

            
        }
        else
        {
            [mLblMessage setHidden:YES];
            [mImgMessageBg setHidden:YES];
            mImgSharedPhoto.frame=CGRectMake(5,5,90,90);
            [mImgSharedPhoto setHidden:NO];
             mMessageView.frame = CGRectMake(162, 5, 100,100);
            [mImgSharedPhoto.layer setCornerRadius:10];
            mImgSharedPhoto.layer.masksToBounds=YES;
             [mImgSharedPhoto setImageWithURL:[NSURL URLWithString:info.mFileUrl] placeholderImage:[UIImage imageNamed:@"bgLightGray.png"]];

        }
        
        mImgMessageBg.image = [[UIImage imageNamed:@"bubbleRight2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 18, 25)];
        mPhotoView.frame = CGRectMake(282+30-40, mMessageView.frame.size.height-40+5, 40, 40);
        [mPhotoView setContentMode:UIViewContentModeScaleAspectFill];
        [mPhotoView setImageWithURL:[NSURL URLWithString:[Engine gPersonInfo].mPhotoUrl]];

    }
    else {
        if([info.mMsgType isEqualToString:MESSAGE_TYPE_NOTE])
        {
            [mImgMessageBg setHidden:NO];
            [mLblMessage setText:[info mMsg]];
            float offset=10.0;
            float width=0;
            CGSize textSize=[self messageSize:info.mMsg font:[UIFont systemFontOfSize:16]];
            textSize.width+=5;
            if(textSize.width>205)
                textSize.width=205;
            // [mLblMessage setTextColor:[AppEngine colorFromString:[Engine gPersonInfo].mColorPartnerText]];
            mLblMessage.frame = CGRectMake(21, offset, textSize.width,textSize.height);
            width=textSize.width;
            offset+=textSize.height;
            [mLblMessage setHidden:NO];
            mMessageView.frame = CGRectMake(40+5, 7, width+30,offset+25);
            
            [mPhotoView setImageWithURL:[NSURL URLWithString:[Engine gCurrentMessageHistory].photourl]];
            
            [mImgMessageBg setFrame:CGRectMake(0, 0, mMessageView.frame.size.width, mMessageView.frame.size.height)];
        }
        else
        {
    
            [mLblMessage setHidden:YES];
            [mImgMessageBg setHidden:YES];
            mImgSharedPhoto.frame=CGRectMake(5,5,90,90);
            [mImgSharedPhoto setHidden:NO];
            mMessageView.frame = CGRectMake(52, 5, 100,100);
            [mImgSharedPhoto.layer setCornerRadius:12];
            mImgSharedPhoto.layer.masksToBounds=YES;
             [mImgSharedPhoto setImageWithURL:[NSURL URLWithString:info.mFileUrl] placeholderImage:[UIImage imageNamed:@"bgLightGray.png"]];
            mImgMessageBg.image = [[UIImage imageNamed:@"bubbleLeft2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 18, 25)];
            
        }
        mImgMessageBg.image = [[UIImage imageNamed:@"bubbleLeft2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 25, 18, 20)];
        [mPhotoView setContentMode:UIViewContentModeScaleAspectFill];
        mPhotoView.frame = CGRectMake(5.0, mMessageView.frame.size.height-40+5, 40, 40);
        [mPhotoView setImageWithURL:[NSURL URLWithString:[Engine gCurrentMessageHistory].photourl]];
        
    }
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
        height+=[message.mMsg boundingRectWithSize:MESSAGEBOUNDARY options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height+5;
    }
    else
    {
        height=110;
        
    }
    return MAX(height, 40.0f);
}

@end
