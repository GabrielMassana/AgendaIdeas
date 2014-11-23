//
//  UIImage+UCCOverlay.m
//  UICommon
//
//  Created by William Boles on 02/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIImage+UCCOverlay.h"

@implementation UIImage (UCCOverlay)

#pragma mark - Overlay

- (UIImage *) ucc_imageWithOverlayColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,
                             0.0f,
                             self.size.width,
                             self.size.height);
    
    if (UIGraphicsBeginImageContextWithOptions)
    {
        CGFloat imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
    else
    {
        UIGraphicsBeginImageContext(self.size);
    }
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *imageWithOverlayColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [imageWithOverlayColor imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
