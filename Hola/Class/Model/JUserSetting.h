//
//  JUserSetting.h
//  Hola
//
//  Created by Jin Wang on 20/3/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JUserSetting : NSObject
@property(nonatomic, strong) NSString *mSettingId;
@property(nonatomic, strong) NSString *mUserId;
@property(nonatomic) NSInteger mLookingGender;
@property(nonatomic) NSInteger mPushNotification;
@property(nonatomic) NSInteger mVisibility;
@property(nonatomic) float mMaxDistance;
@property(nonatomic) NSInteger mMinAge;
@property(nonatomic) NSInteger mMaxAge;



- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;
@end
