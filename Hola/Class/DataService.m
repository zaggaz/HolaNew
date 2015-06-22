//
//  DataService.m
//  Hola
//
//  Created by James Zhao on 07/06/2015.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "DataService.h"
#import "ResponseContainer.h"

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
    _postSuccessHandler = [successHandler copy];
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---Http Post---\n%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        ResponseContainer *response = [[ResponseContainer alloc]initWithResponseData:responseObject];
        
        if (response.success)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
            if(response.responseData.error)
            {
                if([response.responseData.error_type isEqualToString:@"DUPLICATE_EMAIL"])
                {
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_DUPLICATE_EMAIL];
                    return ;
                }
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                _postSuccessHandler(response.responseData.data);
            }
        }
        else
        {
            if (response.invalidToken) {
                [MBProgressHUD hideHUDForView:view animated:YES];
                [SVProgressHUD showErrorWithStatus:MSG_INVALID_TOKEN];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
                
            }else {
                [MBProgressHUD hideHUDForView:view animated:YES];

                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        
    }];    
};

@end
