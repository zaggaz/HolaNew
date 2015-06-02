//
//  JBlurImage.h
//  HeavenlySinful
//
//  Created by Jing on 5/5/14.
//  Copyright (c) 2014 Jing Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (JBlurImage)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
- (UIImage *) fadedImage;
- (UIImage*)resizeImageToSize:(CGSize)newSize;

@end