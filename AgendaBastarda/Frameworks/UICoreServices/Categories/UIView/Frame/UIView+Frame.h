//
//  UIView+Frame.h
//  P1SKit
//
//  Created by Marko Strizic on 10/24/12.
//  Copyright (c) 2012 Marko Strizic. All rights reserved.
//

#import <UIKit/UIKit.h>

CG_EXTERN CGRect CGRectCrop(CGRect rect, CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
CG_EXTERN CGRect CGRectRescale(CGRect rect, CGFloat width, CGFloat height);

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat xRight;
@property (nonatomic, assign) CGFloat yBottom;

-(void) sizeToFitSubviews;

@end
