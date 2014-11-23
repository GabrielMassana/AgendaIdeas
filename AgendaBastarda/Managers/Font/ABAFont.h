//
//  ABAFont.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABAFont : NSObject

+ (UIFont *)openSansLightFontWithSize:(CGFloat)size;
+ (UIFont *)openSansRegularFontWithSize:(CGFloat)size;
+ (UIFont *)openSansSemiboldFontWithSize:(CGFloat)size;
+ (UIFont *)openSansBoldFontWithSize:(CGFloat)size;
+ (UIFont *)openSansExtraBoldFontWithSize:(CGFloat)size;

@end
