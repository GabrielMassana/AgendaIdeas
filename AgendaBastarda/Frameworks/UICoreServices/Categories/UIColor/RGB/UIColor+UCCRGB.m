//
//  UIColor+USNRGB.m
//  UICommon
//
//  Created by William Boles on 10/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIColor+UCCRGB.h"

@implementation UIColor (UUCRGB)

#pragma mark - RGB

+ (UIColor *) ucc_colorWithRGBValuesForRed:(CGFloat)red
                                     green:(CGFloat)green
                                      blue:(CGFloat)blue
                                     alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}


- (CGFloat) ucc_redValue
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    
    [self getRed:&red
           green:&green
            blue:&blue
           alpha:&alpha];
    
    return red*255.0f;
}

- (CGFloat) ucc_greenValue
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    
    [self getRed:&red
           green:&green
            blue:&blue
           alpha:&alpha];
    
    return green*255.0f;
}

- (CGFloat)ucc_blueValue
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    
    [self getRed:&red
           green:&green
            blue:&blue
           alpha:&alpha];
    
    return blue*255.0f;
}

- (CGFloat) ucc_alphaValue
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    
    [self getRed:&red
           green:&green
            blue:&blue
           alpha:&alpha];
    
    return alpha;
}

@end
