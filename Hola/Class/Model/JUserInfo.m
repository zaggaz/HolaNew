

#import "JUserInfo.h"
#import "JPictureInfo.h"

@implementation JUserInfo


@synthesize mUserId;
@synthesize mEmail;
@synthesize mFirstName;
@synthesize mLastName;
@synthesize mUserName;
@synthesize mSessToken;
@synthesize mPhotoUrl;
@synthesize mFacebookId;
@synthesize mGender;
@synthesize mGoogleId;
@synthesize mUserLoginStep;
@synthesize mLocation;
@synthesize mUserPhotoArr;
@synthesize mLat;
@synthesize mLgn;
@synthesize mAge;
@synthesize mBirthday;

@synthesize mDescription;

@synthesize mRegisterDate;
@synthesize mArrPic;



- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setDataWithDictionary:dict];
        mArrPic = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)setDataWithDictionary:(NSDictionary*)dict{

    mArrPic = [[NSMutableArray alloc]init];    
    self.mUserId = [dict objectForKey: @"id"];
    self.mEmail = [dict objectForKey: @"email"];
    self.mFirstName = @"";
    self.mLastName = @"";
    if(![[dict objectForKey:@"firstname"] isKindOfClass:[NSNull class]])
        self.mFirstName = [dict objectForKey: @"firstname"];
    if(![[dict objectForKey:@"lastname"] isKindOfClass:[NSNull class]])
        self.mLastName = [dict objectForKey: @"lastname"];
    
    mUserName = [NSString stringWithFormat:@"%@ %@", self.mFirstName, self.mLastName];
    
    self.mSessToken = [dict objectForKey: @"sesstoken"];
    self.mFacebookId = [dict objectForKey: @"facebook_id"];
    self.mGoogleId = [dict objectForKey: @"google_id"];
    self.mGender = [dict objectForKey: @"gender"];
    
    self.mLat = [[dict objectForKey: @"lat"] floatValue];
    self.mLgn = [[dict objectForKey: @"lgn"] floatValue];
    self.mRegisterDate = [dict objectForKey: @"registerdate"];
    
    self.mAge = [dict objectForKey: @"age"];
    self.mUserLoginStep = [dict objectForKey:@"currentstep"];
    if(![[dict objectForKey:@"description"] isKindOfClass:[NSNull class]])
        mDescription =[dict objectForKey:@"description"];
    
    if(![[dict objectForKey:@"birthday"] isKindOfClass:[NSNull class]])
        mBirthday =[dict objectForKey:@"birthday"];
    if(![[dict objectForKey:@"city"] isKindOfClass:[NSNull class]])
        self.mLocation = [dict objectForKey: @"city"];
    if([[dict objectForKey:@"photourl"] isEqualToString:@""])
        self.mPhotoUrl = @"";
    else if(![[dict objectForKey:@"photourl"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"photourl"] length] > 4)
    {
        if([[[dict objectForKey:@"photourl"] substringToIndex:4] isEqualToString:@"http"])
        {
            self.mPhotoUrl = [dict objectForKey:@"photourl"];
        }
        else
        {
            self.mPhotoUrl = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"photourl"]];
        }
    }
    [self setCurrentUserStep:[dict objectForKey:@"currentstep"]];
    
    if([dict objectForKey:@"photos"])
    {
        //   [Engine gPersonInfo].mArrPic =
        for(int i = 0; i < [[dict objectForKey:@"photos"] count]; i++)
        {
            JPictureInfo *pPicture = [[JPictureInfo alloc]initWithDictionary:[[dict objectForKey:@"photos"] objectAtIndex:i]];
            //NSData *pCurPhoto =[NSKeyedArchiver archivedDataWithRootObject:pPicture];
            [mArrPic addObject:pPicture];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:@"current_user"];
    [defaults synchronize];
    
    return self;

}
- (void)setCurrentUserStep:(NSString *)step
{
    self.mUserLoginStep  = step;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:step forKey:@"current_user_step"];
    [defaults synchronize];
}


@end
