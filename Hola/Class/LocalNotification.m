//
//  LocalNotification.m
//  Hola
//
//  Created by James Zhao on 30/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "LocalNotification.h"
#import "JCNotificationCenter.h"

@implementation LocalNotification

+(void)showNotificationWithString:(NSString*)notificationText{
    [JCNotificationCenter
     enqueueNotificationWithTitle:notificationText
     message:@""
     tapHandler:^{
     }];
}

@end
