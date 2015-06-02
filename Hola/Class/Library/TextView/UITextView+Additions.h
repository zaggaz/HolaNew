//
//  UITextView+Additions.h
//  Speakle
//
//  Created by Gaurav Keshre on 6/18/14.
//  Copyright (c) 2014 Softway Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Additions)

-(BOOL)isEmpty;
-(void)clear;
@end


@interface UITextField (Additions)

-(BOOL)isEmpty;
-(void)clear;

-(void)addErrorInfoButtonWithTarget:(id)target andSelector:(SEL)sel;
-(void)removeErrorInfoButton;
@end
