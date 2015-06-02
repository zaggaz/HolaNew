//
//  AppEngine.h
//  Phonder
//

#import <UIKit/UIKit.h>



#import "JUserInfo.h"
#import "Person.h"

#import "JUserSetting.h"
#define Engine  [AppEngine getInstance]

#define LocalizedString(key) \
    [[Engine currentBundle] localizedStringForKey:(key) value:@"" table:nil]

#define isPhone5    [[UIScreen mainScreen] bounds].size.height > 480 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone



@interface AppEngine : NSObject  {

     NSString                * _gSrvTime;

   
}
@property (nonatomic) BOOL           gMenuTouched;

@property (nonatomic, retain) NSString           * gSrvTime;
@property (nonatomic, retain) JUserInfo         * gPersonInfo;
@property (nonatomic, retain) NSString              *mProfilePhotoUrl;

@property (nonatomic, retain) NSString * gPopedView;
@property (nonatomic) BOOL            isBackAction;

@property (nonatomic, retain) JUserSetting *gUserSetting;

@property (nonatomic)  float    gUserCurrentLatitude;
@property (nonatomic)  float    gUserCurrentLongitude;
@property (nonatomic, retain) UIColor *  gContentBorderColor;
@property (nonatomic, retain) NSDictionary            * captureInfo;
@property (nonatomic, retain) NSMutableArray            * soundMeters;
@property (nonatomic,retain) NSString            * audioUrl;
@property (nonatomic) BOOL            recordCancel;

@property (nonatomic, retain) Person           * gCurrentMessageHistory;
@property (nonatomic, retain) NSString           * gNewMessagesCount;


@property (nonatomic, retain) UIImage            * gVideoImage;
@property (nonatomic,retain) NSURL            * gVideoUrl;
@property (nonatomic,retain) NSString            * gPlayVideoUrl;
+ (UIColor *) colorFromString:(NSString *)colorStr;
#pragma mark singleton
+ (id)getInstance;
#pragma mark
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;

- (NSString *)base64Encode:(NSString *)plainText;
- (NSString *)base64Decode:(NSString *)base64String;

- (void)setProfilePhotoUrl : (NSString*)photoUrl;
- (void)setPopedView :(NSString *)value;

+(NSString *) getTimeOffsetStr :(NSInteger )delta;
+ (BOOL) validEmail:(NSString*) emailString;
+(CGSize)messageSize:(NSString*)message font:(UIFont*)font  width:(NSInteger)width;
+ (UIImage*)blurWithCoreImage:(UIImage *)sourceImage viewController:(UIViewController *)viewController;
+ (NSInteger)ageFromBirthday:(NSDate *)birthdate;



@property(nonatomic) BOOL bUserSettingChanged;

@end

