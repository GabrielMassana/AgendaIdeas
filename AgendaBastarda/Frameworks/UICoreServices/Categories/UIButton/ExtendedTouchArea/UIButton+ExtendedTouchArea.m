//
//  UIButton+ExtendedTouchArea.m
//  UICoreServices
//
//  Created by William Boles on 06/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIButton+ExtendedTouchArea.h"
#import <objc/runtime.h>

@implementation UIButton (UUCExtendedTouchArea)

#pragma mark - Property

@dynamic ucc_extendedTouchAreaEdgeInsets;

static const NSString *kUCCExtendedTouchAreaEdgeInsets = @"ucc_extendedTouchAreaEdgeInsets";

- (void) setUcc_extendedTouchAreaEdgeInsets:(UIEdgeInsets)extendedTouchAreaEdgeInsets
{
    NSValue *value = [NSValue value:&extendedTouchAreaEdgeInsets
                       withObjCType:@encode(UIEdgeInsets)];
    
    objc_setAssociatedObject(self, &kUCCExtendedTouchAreaEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets) ucc_extendedTouchAreaEdgeInsets
{
    UIEdgeInsets extendedTouchAreaEdgeInsets = UIEdgeInsetsZero;
    
    NSValue *value = objc_getAssociatedObject(self, &kUCCExtendedTouchAreaEdgeInsets);
    
    if(value)
    {
        [value getValue:&extendedTouchAreaEdgeInsets];
    }
    
    return extendedTouchAreaEdgeInsets;
}

#pragma mark - ExtendedTouchArea

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.ucc_extendedTouchAreaEdgeInsets, UIEdgeInsetsZero) ||
       !self.enabled ||
       self.hidden)
    {
        return [super pointInside:point
                        withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect touchAreaFrame = UIEdgeInsetsInsetRect(relativeFrame,
                                                  self.ucc_extendedTouchAreaEdgeInsets);
    
    BOOL pointInside = CGRectContainsPoint(touchAreaFrame,
                                           point);
    
    return pointInside;
}


@end
