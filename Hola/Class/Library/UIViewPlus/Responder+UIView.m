//
//  Responder+UIView.m
//  RandomPal
//
//  Created by Daniel on 11/21/14.
//  Copyright (c) 2014 Diana Naikova. All rights reserved.
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
