//
//  ResponseData.h
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseData : NSObject

@property (nonatomic) BOOL error;
@property (nonatomic) NSArray* data;

- (id) initWithDictionary: (NSDictionary *)dataDictionary;

@end
