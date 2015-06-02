//
//  UITextView+Additions.m
//  Speakle
//
//  Created by Gaurav Keshre on 6/18/14.
//  Copyright (c) 2014 Softway Solutions. All rights reserved.
//

#import "UITextView+Additions.h"

@implementation UITextView (Additions)

-(BOOL)isEmpty{
    BOOL flag = NO;
    NSString *str = [self text];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([str length]<1) {
        flag = flag || YES;
    }
    return flag;
}


-(void)clear{
    [self setText:@""];
}
@end

@implementation UITextField (Additions)

-(BOOL)isEmpty{
    BOOL flag = NO;
    NSString *str = [self text];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([str length]<1) {
        flag = flag || YES;
    }
    return flag;
}


-(void)clear{
    [self setText:@""];
}


-(void)addErrorInfoButtonWithTarget:(id)target andSelector:(SEL)sel{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:@"icon-error.png"] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.tag;
    [self setRightView:button];
    [self setRightViewMode:UITextFieldViewModeUnlessEditing];
}

-(void)removeErrorInfoButton{
    [self setRightView:nil];
}

@end

