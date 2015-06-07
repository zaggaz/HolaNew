//
//  ResponseData.m
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "ResponseData.h"

@implementation ResponseData

@synthesize error = _error;

- (id) init {
    if (self = [super init]) {
        [self setError:YES];
    }
    return self;
};

- (id) initWithDictionary: (NSDictionary *)dataDictionary {
    if (self = [super init]){
        NSString *error = [dataDictionary objectForKey: @"error"];
        if ([error isEqualToString:@"1"]) {
            [self setError:YES];
            [self setData:nil];
        }else if([error isEqualToString:@"0"]) {
            [self setError:NO];
            [self setData:[dataDictionary objectForKey:@"result"]];
        }
    }
    return self;
};

@end
