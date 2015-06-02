//
//  Responder+UIView.m
//  Created by JinWang on 23/4/15.
//  Copyright (c) 2015 Hola. All rights reserved.
//

#import "Responder+UIView.h"

@implementation UIView (Responder_UIView)
-(id) findFirstResponder
{
    if (self.isFirstResponder)
    {
        return self;
    }
    for (UIView *subView in self.subviews)
    {
        id responder = [subView findFirstResponder];
        if (responder) return  responder;
    }
    return nil;
}
@end
