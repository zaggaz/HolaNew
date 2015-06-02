//
//  JPictureInfo.m
//  Hola
//
//  Created by JinWang on 23/4/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//


#import "JPictureInfo.h"



@implementation JPictureInfo

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setDataWithDictionary:dict];
    }
    return self;
}


- (id)setDataWithDictionary:(NSDictionary*)dict {
    self.mPhotoId            = [dict objectForKey: @"id"];
    self.mPhotoType     = [dict objectForKey: @"phototype"];
    if([[[dict objectForKey:@"photourl"] substringToIndex:4] isEqualToString:@"http"])
    {
        self.mFileUrl = [dict objectForKey:@"photourl"];
    }
    else
    {
        self.mFileUrl = [NSString stringWithFormat:@"%@%@%@",WEB_SITE_BASE_URL,@"webservice/",[dict objectForKey:@"photourl"]];
    }
    if(![[dict objectForKey:@"thumburl"] isKindOfClass:[NSNull class]])
        self.mThumbUrl     = [dict objectForKey: @"thumburl"];
    
    return self;
}

@end
