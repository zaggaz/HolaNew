//
//  JViewController.h
//  Hola
//
//  Created by Jin Wang on 30/3/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JViewController : UIViewController<CLLocationManagerDelegate>
{
    JASidePanelController       *mJASidePanel;
    IBOutlet UIButton *mBtnLogin;
    IBOutlet UIButton *mBtnFacebookLogin;
    
    float latitude;
    float longitude;
}
+ ( JViewController* ) sharedController;
@property(nonatomic, strong)    CLLocationManager *locationManager;
@end
