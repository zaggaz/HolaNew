
#import <Foundation/Foundation.h>
#define MESSAGE_TYPE_NOTE   @"1"
#define MESSAGE_TYPE_PHOTO   @"2"


@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *photourl;
@property (nonatomic, assign) NSUInteger age;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) NSInteger userid;

@property (nonatomic, strong) NSString *description;


@property (nonatomic, assign) NSString *latitude;
@property (nonatomic, assign) NSString *longitude;

@property (nonatomic, retain) NSString    *mNewMsgNum;
@property (nonatomic, retain) NSString    *mLastMsg;
@property (nonatomic, retain) NSString    *mLastMsgDate;

@property (nonatomic) NSInteger    mSettime;



@property (nonatomic, assign) NSUInteger numberOfSharedFriends;
@property (nonatomic, assign) NSUInteger numberOfSharedInterests;
@property (nonatomic, assign) NSUInteger numberOfPhotos;
@property (nonatomic, assign) NSString *birthday;
@property (nonatomic) NSInteger likeorder;


- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                         age:(NSUInteger)age
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
              numberOfPhotos:(NSUInteger)numberOfPhotos;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;
@end


@interface JMessageInfo : NSObject
{
}

@property (nonatomic, retain) NSString    *mUserId;
@property (nonatomic, retain) NSString    *mPartnerId;
@property (nonatomic, retain) NSString    *mMsg;
@property (nonatomic, retain) NSString    *mTimeStamp;
@property (nonatomic, retain) NSString    *mMsgType;
@property (nonatomic, retain) NSString    *mFileUrl;
- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;
@end


@interface JMessageHistoryInfo : NSObject
{
}

@property (nonatomic, retain) NSString    *mUserId;
@property (nonatomic, retain) NSString    *mPhoto;
@property (nonatomic, retain) NSString    *mUserName;
@property (nonatomic, retain) NSString    *mFullName;

@property (nonatomic, retain) NSString    *mNewMsgNum;
@property (nonatomic, retain) NSString    *mLastMsg;
@property (nonatomic, retain) NSString    *mLastMsgDate;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;
@end