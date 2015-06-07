//
//  ResponseContainer.h
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseData.h"


@interface ResponseContainer : NSObject

@property (nonatomic, retain) ResponseData *responseData;
@property (nonatomic) BOOL success;
@property (nonatomic) BOOL invalidToken;



- (id) initWithResponseData: (NSData *)responseData;

@end
