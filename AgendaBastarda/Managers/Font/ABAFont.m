//
//  ABAFont.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAFont.h"

@implementation ABAFont

+ (UIFont *)openSansLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (UIFont *)openSansRegularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)openSansSemiboldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
}

+ (UIFont *)openSansBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (UIFont *)openSansExtraBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-ExtraBold" size:size];
}

@end
