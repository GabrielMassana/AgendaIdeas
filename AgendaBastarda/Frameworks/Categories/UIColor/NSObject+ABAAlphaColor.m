//
//  NSObject+ABAAlphaColor.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 18/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "NSObject+ABAAlphaColor.h"

@implementation UIColor (ABAAlphaColor)

- (UIColor *)aba_newColorForPlaceholder
{
    UIColor *chooseColor = self;
    
    CGFloat red, green, blue, alpha;
    [chooseColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    UIColor *returnColor;
    
    if (red == 0.0f &&
        green == 0.0f &&
        blue == 0.0f)
    {
        returnColor = [UIColor grayColor];
    }
    else if (red > 0.0f && red < 1.0f &&
             green > 0.0f &&  green < 1.0f &&
             blue > 0.0f && blue < 1.0f)
    {
        red = red * 1.5;
        green = green * 1.5;
        blue = blue * 1.5;
        
        returnColor = [UIColor colorWithRed:red
                                      green:green
                                       blue:blue
                                      alpha:1.0];
    }
    else
    {
        if (red == 0.0f)
        {
            red = 0.0f;
        }
        else if (red < 1.0f)
        {
            red = red * 1.5;
        }
        
        
        if (green == 0.0f)
        {
            green = 0.0f;
        }
        else if (green < 1.0f)
        {
            green = green * 1.5;
        }
        

        if (blue == 0.0f)
        {
            blue = 0.0f;
        }
        else if (blue < 1.0f)
        {
            blue = blue * 1.5;
        }
        
        returnColor = [UIColor colorWithRed:red
                                      green:green
                                       blue:blue
                                      alpha:1.0];

    }
    
    return returnColor;
}

@end