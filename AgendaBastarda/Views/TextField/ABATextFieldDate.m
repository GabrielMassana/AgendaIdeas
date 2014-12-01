//
//  ABATextFieldDate.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 26/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABATextFieldDate.h"

typedef NS_ENUM(NSUInteger, ABATextFieldConstraintsFase)
{
    ABATextFieldConstraintsFaseUnknown  = 0,
    ABATextFieldConstraintsFaseLeft     = 1,
    ABATextFieldConstraintsFaseRight    = 2,
};

@interface ABATextFieldDate ()

@property (nonatomic, assign) ABATextFieldConstraintsFase constraintsFase;
@property (nonatomic, strong) UIView *separationLine;

@property (nonatomic, strong) NSLayoutConstraint *constraintAlignHorizontal;
@property (nonatomic, strong) NSLayoutConstraint *constraintLeft;
@property (nonatomic, strong) NSLayoutConstraint *constraintRight;

@end

@implementation ABATextFieldDate

#pragma mark - Init


- (void)textDidChange
{
    [super textDidChange];
    
    self.movablePlaceholder.textColor = [self.movablePlaceholder.textColor colorWithAlphaComponent:1.0f];
}

@end