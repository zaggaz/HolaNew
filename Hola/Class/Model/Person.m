

#import "Person.h"


@implementation JMessageInfo
@synthesize mUserId;//         = _mUserId;
@synthesize mMsgType;//      = _mMsgType;
@synthesize mMsg;//        = _mMsg;
@synthesize mTimeStamp;//  = _mTimeStamp;
@synthesize mPartnerId;
@synthesize mFileUrl;

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        //        _mArrLike        = [[NSMutableArray alloc] init];
        [self setDataWithDictionary:dict];
    }
    return self;
}


- (id)setDataWithDictionary:(NSDictionary*)dict {
    self.mUserId = [dict objectForKey: @"userid"];
    
    if([self.mUserId isEqualToString:[Engine gPersonInfo].mUserId])
    {
        self.mPartnerId=[dict objectForKey:@"partner_id"];
    }
    else
    {
        self.mPartnerId=self.mUserId;
    }
    self.mMsgType = [dict objectForKey: @"msgtype"];
    self.mMsg = [Engine base64Decode:[dict objectForKey: @"message"]];
    self.mTimeStamp = [dict objectForKey: @"msgdate"];
    if([[dict objectForKey: @"fileurl"] length] > 4)
    {
        if([[[dict objectForKey:@"fileurl"] substringToIndex:4] isEqualToString:@"http"])
        {
            self.mFileUrl = [dict objectForKey:@"fileurl"];
        }
        else
        {
            self.mFileUrl = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"fileurl"]];
        }
        
    }
    else
    {
        self.mFileUrl = @"";
    }
    
    
    return self;
}

@end





@implementation JMessageHistoryInfo

@synthesize mUserId;//           = _mUserId;
//@synthesize mPostSpecificId;//         = _mPostSpecificId;
@synthesize mUserName;//         =_mMadeupName;
@synthesize mPhoto;//         =_mMadeupName;
@synthesize mNewMsgNum;//       = _mNewMsgNum;
@synthesize mLastMsg;//;//=_mLastMsg;
@synthesize mLastMsgDate;
@synthesize mFullName;


- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        //        _mArrLike        = [[NSMutableArray alloc] init];
        [self setDataWithDictionary:dict];
    }
    return self;
}


- (id)setDataWithDictionary:(NSDictionary*)dict {
    if([[[dict objectForKey:@"photourl"] substringToIndex:4] isEqualToString:@"http"])
    {
        self.mPhoto = [dict objectForKey:@"photourl"];
        //self.mPhoto = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"photourl"]];
    }
    else
    {
        self.mPhoto = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"photourl"]];
    }
    self.mUserName=[dict objectForKey:@"email"];
    self.mFullName=[dict objectForKey:@"fullname"];
    
    self.mLastMsgDate=[dict objectForKey:@"lastmsgdate"];
    self.mLastMsg = [Engine base64Decode:[dict objectForKey: @"lastmsg"]];
    if([[Engine gPersonInfo].mUserId isEqualToString:[dict objectForKey:@"userid"]])
    {
        self.mUserId = [dict objectForKey: @"partner_id"];
        self.mNewMsgNum=[dict objectForKey:@"newmsgme"];
    }
    else
    {
        self.mUserId = [dict objectForKey: @"user_id"];
        self.mNewMsgNum=[dict objectForKey:@"newmsgpartner"];
    }
    
    
    return self;
}
@end


@implementation Person
@synthesize description;
@synthesize mLastMsg;
@synthesize mLastMsgDate;
@synthesize mNewMsgNum;
@synthesize name;
@synthesize photourl;
@synthesize latitude;
@synthesize longitude;
@synthesize gender;
@synthesize birthday;
@synthesize userid;
@synthesize age;
@synthesize likeorder;
@synthesize mSettime;


#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                         age:(NSUInteger)age
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
              numberOfPhotos:(NSUInteger)numberOfPhotos {
    self = [super init];
    if (self) {
        self.name = name;
       // _image = image;
        self.age = age;
        _numberOfSharedFriends = numberOfSharedFriends;
        _numberOfSharedInterests = numberOfSharedInterests;
        _numberOfPhotos = numberOfPhotos;
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setDataWithDictionary:dict];
    }
    return self;
}

- (id)setDataWithDictionary:(NSDictionary*)dict{
    name = [NSString stringWithFormat:@"%@ %@", [dict objectForKey: @"firstname"], [dict objectForKey: @"lastname"]];
    mNewMsgNum = @"";
    if(![[dict objectForKey:@"photourl"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"photourl"] length] > 4)
    {
        if([[[dict objectForKey:@"photourl"] substringToIndex:4] isEqualToString:@"http"])
        {
            photourl= [dict objectForKey:@"photourl"];
        }
        else
        {
            photourl = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"photourl"]];
        }
    }
    birthday = @"";
    if(![[dict objectForKey:@"birthday"] isKindOfClass:[NSNull class]])
        birthday = [dict objectForKey:@"birthday"];
    
  //  _age = 0;
    if([dict objectForKey:@"settime"]  && ![[dict objectForKey:@"settime"] isKindOfClass:[NSNull class]])
    {
        mSettime = [[dict objectForKey:@"settime"] integerValue];
    }
    if([dict objectForKey:@"msgtime"]  && ![[dict objectForKey:@"msgtime"] isKindOfClass:[NSNull class]])
    {
        mLastMsgDate = [dict objectForKey:@"msgtime"] ;
        mLastMsg = [Engine base64Decode:[dict objectForKey: @"lastmsg"]];
    }
    
    
    if(![birthday isEqualToString:@""])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormatter dateFromString:birthday];
        if(date)
            age = [AppEngine ageFromBirthday:date];
    }
    gender = [[dict objectForKey:@"gender"] integerValue];
    userid = [[dict objectForKey:@"id"] integerValue];
    latitude = 0; longitude = 0;
    
    if([dict objectForKey:@"lat"] && ![[dict objectForKey:@"lat"] isKindOfClass:[NSNull class]])
        latitude =[dict objectForKey:@"lat"];
    if([dict objectForKey:@"lgn"] && ![[dict objectForKey:@"lgn"] isKindOfClass:[NSNull class]])
        longitude =[dict objectForKey:@"lgn"];
     description = [dict objectForKey:@"description"];
    
    likeorder = 0;
    if([dict objectForKey:@"likeorder"])
        likeorder = [[dict objectForKey:@"likeorder"]integerValue];

    
    //_name = [dict objectForKey:@"email"];
    
    return self;
}
@end
