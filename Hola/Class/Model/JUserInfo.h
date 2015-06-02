//
//  JUserInfo.h
//  Hola
//  Created by JinWang on 23/4/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface JUserInfo : NSObject


@property (nonatomic, retain) NSString    *mUserId;
@property (nonatomic, retain) NSString    *mEmail;
@property (nonatomic, retain) NSString    *mFirstName;
@property (nonatomic, retain) NSString    *mLastName;
@property (nonatomic, retain) NSString    *mUserName;
@property (nonatomic, retain) NSString    *mSessToken;

@property (nonatomic, retain) NSString    *mFacebookId;
@property (nonatomic, retain) NSString    *mPhotoUrl;
@property (nonatomic,retain) NSString     *mGender;
@property (nonatomic, retain) NSString    *mGoogleId;

@property (nonatomic, retain) NSString    *mLocation;
@property (nonatomic, retain) NSString    *mRegisterDate;
@property (nonatomic, retain) NSString    *mAge;
@property (nonatomic, retain) NSDate    *mBirthday;

@property (nonatomic, retain) NSString    *mUserLoginStep;

@property (nonatomic, retain) NSMutableArray *mUserPhotoArr;
@property (nonatomic)   float   mLat;
@property (nonatomic)   float   mLgn;




@property(nonatomic, strong) NSString *mDescription; // about me;

@property(nonatomic, retain) NSMutableArray *mArrPic;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;
- (void)setCurrentUserStep:(NSString*)step;


@end
