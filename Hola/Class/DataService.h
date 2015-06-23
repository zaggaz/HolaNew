//
//  DataService.h
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject {
    void (^_postSuccessHandler)(NSDictionary *data);
}

+ (id)sharedDataService;
-(void)postWithParameters:(NSMutableDictionary *)params successHandler:(void(^)(NSArray*))successHandler currentView:(UIView *)view;
@end
