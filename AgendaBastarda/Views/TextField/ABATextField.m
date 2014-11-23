//
//  ABATextField.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 17/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABATextField.h"
#import "NSObject+ABAAlphaColor.h"

typedef NS_ENUM(NSUInteger, ABATextFieldConstraintsFase)
{
    ABATextFieldConstraintsFaseUnknown  = 0,
    ABATextFieldConstraintsFaseLeft     = 1,
    ABATextFieldConstraintsFaseRight    = 2,
};

@interface ABATextField ()

@property (nonatomic, assign) ABATextFieldConstraintsFase constraintsFase;
@property (nonatomic, strong) UIView *separationLine;

@property (nonatomic, strong) NSLayoutConstraint *constraintAlignHorizontal;
@property (nonatomic, strong) NSLayoutConstraint *constraintLeft;
@property (nonatomic, strong) NSLayoutConstraint *constraintRight;

@end

@implementation ABATextField

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.movablePlaceholder];
        [self addSubview:self.separationLine];
        
        [self setUpNotification];
        
        [self setUpConstraint];
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    return self;
}

#pragma mark - Subviews

- (UILabel *)movablePlaceholder
{
    if (!_movablePlaceholder)
    {
        _movablePlaceholder = [UILabel new];
        _movablePlaceholder.translatesAutoresizingMaskIntoConstraints = NO;

        _movablePlaceholder.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _movablePlaceholder.textAlignment = NSTextAlignmentLeft;
        _movablePlaceholder.frame = self.frame;
        
        [_movablePlaceholder sizeToFit];
    }
    
    return _movablePlaceholder;
}

- (UIView *)separationLine
{
    if (!_separationLine)
    {
        _separationLine = [UIView newAutoLayoutView];
        _separationLine.backgroundColor = [UIColor blackColor];
    }
    
    return _separationLine;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*-------------------*/
    
    if (self.constraintsFase == ABATextFieldConstraintsFaseUnknown)
    {
        [self.separationLine autoSetDimension:ALDimensionHeight toSize:1.5f];
        
        [self.separationLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [self.separationLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [self.separationLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        
        [self addConstraint:self.constraintLeft];
        [self addConstraint:self.constraintAlignHorizontal];
    }
}

- (void)setUpConstraint
{
    self.constraintLeft = [NSLayoutConstraint constraintWithItem:self.movablePlaceholder
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1.0f
                                                        constant:10.0f];
    
    self.constraintRight = [NSLayoutConstraint constraintWithItem:self.movablePlaceholder
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:-10.0f];
    
    self.constraintAlignHorizontal = [NSLayoutConstraint constraintWithItem:self.movablePlaceholder
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
}

- (void)setLeftConstraints
{
    [self removeConstraint:self.constraintRight];
    [self addConstraint:self.constraintLeft];
}

- (void)setRightConstraints
{
    [self removeConstraint:self.constraintLeft];
    [self addConstraint:self.constraintRight];
}

#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder
{
    self.movablePlaceholder.text = placeholder;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    self.movablePlaceholder.textColor = [self.textColor aba_newColorForPlaceholder];
    [[UITextField appearance] setTintColor:textColor];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.movablePlaceholder.font = font;
}

#pragma mark - Notifications

- (void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidBeginEditing)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidEndEditing)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
}

- (void)textDidBeginEditing
{
}

- (void)textDidChange
{
    NSUInteger textLength = self.text.length;
    self.movablePlaceholder.textColor = [self.movablePlaceholder.textColor colorWithAlphaComponent:[self calculateNewAlphaFrom:textLength]];
    
    if (textLength == 0)
    {
        self.constraintsFase = ABATextFieldConstraintsFaseLeft;
    }
    else
    {
        self.constraintsFase = ABATextFieldConstraintsFaseRight;
    }
    
    [self animatePlaceholder];
}

- (void)textDidEndEditing
{
    NSInteger textLength = self.text.length;
    
    if (textLength == 0)
    {
        self.constraintsFase = ABATextFieldConstraintsFaseLeft;
        [self animatePlaceholder];
    }
}

#pragma mark - Animations

- (void)animatePlaceholder
{
    [self layoutIfNeeded];

    if (self.constraintsFase == ABATextFieldConstraintsFaseLeft)
    {
        [self setLeftConstraints];
    }
    else if(self.constraintsFase == ABATextFieldConstraintsFaseRight)
    {
        [self setRightConstraints];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self layoutIfNeeded];
     }
                     completion:^(BOOL finished)
    {
    }];
}

#pragma mark - TextPosition

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,
                       10,
                       0);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,
                       10,
                       0);
}

#pragma mark - PlacegholderAlpha

- (CGFloat)calculateNewAlphaFrom:(NSUInteger)integer
{
    CGFloat floatReturn = 0.0f;
    
    if (integer <= 10)
    {
        floatReturn = (((-sqrt(integer)) + 3.2f) / 3.2);
        
        if (floatReturn < 0.0f)
        {
            floatReturn = 0.0f;
        }
    }
    
    return floatReturn;
}

#pragma mark - MemoryManagement

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
