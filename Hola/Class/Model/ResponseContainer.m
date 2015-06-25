//
//  ResponseContainer.m
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "ResponseContainer.h"

@implementation ResponseContainer {
    
}

@synthesize success = _success;
@synthesize invalidToken = _invalidToken;

- (id) initWithResponseData: (NSData *)data {
    if (self = [super init]) {
        NSError *error = nil;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:NSJSONReadingAllowFragments error:&error];
        NSString *successString = [dict objectForKey: @"success"];
        if ([successString isEqualToString: @"1"]) {
            [self setSuccess:YES];
            [self setInvalidToken:NO];
            [self setResponseData: [[ResponseData alloc]initWithDictionary:[dict objectForKey: @"data"]]];
        } else {
            [self setSuccess:NO];
            if ([[dict objectForKey: @"data"] isEqualToString:@"INVALID_TOKEN"]) {
                [self setInvalidToken:YES];
                [self setResponseData: [[ResponseData alloc]init]];
            }
        }
    }
    return self;
}

@end
