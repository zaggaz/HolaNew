//
//  DataService.m
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "DataService.h"
#import "ResponseContainer.h"
#import "LocalNotification.h"


@implementation DataService {
    AFHTTPRequestOperationManager *manager;
}


+ (DataService *)sharedDataService {
    static DataService *sharedDataService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataService = [[self alloc] init];
    });
    return sharedDataService;
}

-(DataService *)init {
    if (self = [super init]){
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)postWithParameters:(NSMutableDictionary *)params successHandler:(void(^)(NSArray*))successHandler currentView:(UIView *)view
{
    [self postWithParameters:params successHandler:successHandler errorHandler:^{
    } currentView:view showLoading:NO];
};

-(void)postWithParameters:(NSMutableDictionary *)params successHandler:(void(^)(NSArray*))successHandler errorHandler:(void(^)())errorHandler currentView:(UIView *)view
{
    [self postWithParameters:params successHandler:successHandler errorHandler:errorHandler currentView:view showLoading:NO];
};

-(void)postWithParameters:(NSMutableDictionary *)params successHandler:(void(^)(NSArray*))successHandler errorHandler:(void(^)())errorHandler currentView:(UIView *)view  showLoading:(BOOL)showLoading
{
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        ResponseContainer *response = [[ResponseContainer alloc]initWithResponseData:responseObject];
        
        if (response.success)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
            if(response.responseData.error)
            {
                if (response.responseData.error_type) {
                    [self showNotification:showLoading message:response.responseData.error_type];
                }
                else{
                    [self showNotification:showLoading message:MSG_SERVICE_UNAVAILABLE];
                }
                errorHandler();
//                if([response.responseData.error_type isEqualToString:@"DUPLICATE_EMAIL"])
//                {
//                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_DUPLICATE_EMAIL];
//                    return ;
//                }
//                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                successHandler(response.responseData.data);
            }
        }
        else
        {
            if (response.invalidToken) {
                [MBProgressHUD hideHUDForView:view animated:YES];
                [self showNotification:showLoading message:MSG_INVALID_TOKEN];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
            }else {
                [MBProgressHUD hideHUDForView:view animated:YES];
                [self showNotification:showLoading message:MSG_SERVICE_UNAVAILABLE];
                errorHandler();
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
//        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        [LocalNotification showNotificationWithString:MSG_SERVICE_UNAVAILABLE];
        errorHandler();
    }];
};

-(void)showNotification:(BOOL)showLoading message:(NSString*)message{
    if (showLoading==YES){
        [SVProgressHUD showErrorWithStatus:message];
    }else {
        [LocalNotification showNotificationWithString:message];
    }
}

@end
