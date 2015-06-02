//
//  JPictureInfo.h
//  Hola
//
//  Created by JinWang on 23/4/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPictureInfo : NSObject

@property (nonatomic, retain) NSString    *mPhotoId;
@property (nonatomic, retain) NSString    *mUserId;
@property (nonatomic, retain) NSString    *mPhotoType;
@property (nonatomic, retain) NSString    *mThumbUrl;
@property (nonatomic, retain) NSString    *mFileUrl;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)setDataWithDictionary:(NSDictionary*)dict;

@end
