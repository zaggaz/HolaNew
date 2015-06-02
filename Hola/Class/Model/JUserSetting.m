//
//  JUserSetting.m
//  Hola
//
//  Created by Jin Wang on 20/3/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//

#import "JUserSetting.h"

@implementation JUserSetting
@synthesize mLookingGender;
@synthesize mMaxAge;
@synthesize mMaxDistance;
@synthesize mMinAge;
@synthesize mPushNotification;
@synthesize mSettingId;
@synthesize mUserId;
@synthesize mVisibility;

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setDataWithDictionary:dict];
    }
    return self;
}

- (id)setDataWithDictionary:(NSDictionary*)dict{
    mSettingId = [dict objectForKey: @"id"];
    mUserId = [dict objectForKey: @"user_id"];
    
    mLookingGender = [[dict objectForKey: @"looking_gender"] integerValue];
    mPushNotification = [[dict objectForKey: @"push_notification"] integerValue];
    mVisibility = [[dict objectForKey: @"visibility"] integerValue];
    mMinAge = [[dict objectForKey: @"min_age"] integerValue];
    mMaxAge = [[dict objectForKey: @"max_age"] integerValue];
    mMaxDistance = [[dict objectForKey: @"max_distance"] floatValue];    
    return self;
}

@end
