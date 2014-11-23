//
//  UIImage+UCCColor.m
//  UICommon
//
//  Created by William Boles on 25/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIImage+UCCColor.h"

@implementation UIImage (UCCColor)

+ (UIImage *) ucc_imageWithColor:(UIColor *)color size:(CGSize)size
{
    /*---------------*/
    
    UIGraphicsBeginImageContext(size);
    
    /*---------------*/
    
    UIBezierPath *rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      size.width,
                                                                      size.height)];
    [color setFill];
    [rPath fill];
    
    /*---------------*/
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*---------------*/
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
