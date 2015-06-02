//
//  JBlurImage.m
//  HeavenlySinful
//
//  Created by Jing on 5/5/14.
//  Copyright (c) 2014 Jing Mobile. All rights reserved.
//

#import "JBlurImage.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (FXBlurView)

- (UIImage *) fadedImage{

    CIFilter* hueAdjust;
    CIFilter* blurAdjust;
    
    blurAdjust = [CIFilter filterWithName:@"CIGaussianBlur"];
    hueAdjust = [CIFilter filterWithName:@"CIColorControls"];
    
    CIImage* originalImage = [CIImage imageWithCGImage:self.CGImage];
    
    [blurAdjust setValue:originalImage forKey:kCIInputImageKey];
    [blurAdjust setValue:@3 forKey:kCIInputRadiusKey];
    
    CIImage* blurredImage = [blurAdjust valueForKey:kCIOutputImageKey];
    
    [hueAdjust setValue:blurredImage forKey:kCIInputImageKey];
    [hueAdjust setValue:@0.0 forKey:kCIInputSaturationKey];
    
    CIImage* outputImage = [hueAdjust valueForKey:kCIOutputImageKey];
    
    // Convert the result to a UIImage. (This is another time-sink, since
    // we need to pull pixels from the GPU into the CPU, which is slow.
    
    UIImage* fadedImage = [UIImage imageWithCIImage:outputImage scale:1 orientation:UIImageOrientationUp];
    
    NSLog(@"Faded Image: Width: %f Height: %f",fadedImage.size.width,fadedImage.size.height);
    return fadedImage;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        NSLog(@"Alpha: %f",(radius-1)/10.0);
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:(radius-1)/10.0].CGColor);
        //        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextSetBlendMode(ctx, kCGBlendModeDarken);
//        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
//        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}


- (UIImage*)resizeImageToSize:(CGSize)newSize
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGFloat scaleRatio =newSize.width/width;
    if(scaleRatio<(newSize.height/height))
    {
        scaleRatio=newSize.height/height;
    }
    
    
    UIGraphicsBeginImageContext( newSize );
    //    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [self drawInRect:CGRectMake((newSize.width-width*scaleRatio)/2.0,(newSize.height-height*scaleRatio)/2.0,width*scaleRatio,height*scaleRatio)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
