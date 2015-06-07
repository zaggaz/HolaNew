//
//  JHomeViewController.h
//  Hola
//
//  Created by Jin Wang on 2/4/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"
#import "ChoosePersonView.h"

@interface JHomeViewController : UIViewController<MDCSwipeToChooseDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *mViewPhotoFrame;
    UITapGestureRecognizer* recognizer;
    
    CALayer *waveLayer;

    IBOutlet UIView *mViewSearchContainer;
    IBOutlet UIImageView *mImgUserPhoto;
}
@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;
@property (nonatomic, strong) NSMutableArray *people;

@property (nonatomic, strong) NSMutableArray *mArrUsers;

+ ( JHomeViewController* ) sharedController;
@end
