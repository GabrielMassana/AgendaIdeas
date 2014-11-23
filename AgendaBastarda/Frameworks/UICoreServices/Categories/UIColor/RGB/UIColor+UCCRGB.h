//
//  UIColor+USNRGB.h
//  UICommon
//
//  Created by William Boles on 10/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UUCRGB)

+ (UIColor *) ucc_colorWithRGBValuesForRed:(CGFloat)red
                                     green:(CGFloat)green
                                      blue:(CGFloat)blue
                                     alpha:(CGFloat)alpha;


- (CGFloat) ucc_redValue;
- (CGFloat) ucc_greenValue;
- (CGFloat) ucc_blueValue;
- (CGFloat) ucc_alphaValue;

@end
