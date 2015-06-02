//
//  UIPlaceHolderTextView.h
//  Created by JinWang on 23/4/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
