//
//  JHomeViewController.h
//  Hola
//
//  Created by Jin Wang on 1/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSearchViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *mImgUserPhoto;
}
+ ( JSearchViewController* ) sharedController;
@end
