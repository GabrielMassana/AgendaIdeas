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
    ABATextFieldConstraintsFaseLeft = 0,
    ABATextFieldConstraintsFaseRight = 1,
};

@interface ABATextField ()

@property (nonatomic, strong) NSLayoutConstraint *movablePlaceholderAutoPinEdgeToSuperviewEdge;
@property (nonatomic, assign) ABATextFieldConstraintsFase constraintsFase;
@property (nonatomic, strong) UIView *separationLine;

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

        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    return self;
}

#pragma mark - Subviews

- (UILabel *)movablePlaceholder
{
    if (!_movablePlaceholder)
    {
        _movablePlaceholder = [UILabel newAutoLayoutView];

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
    
    [self.separationLine autoSetDimension:ALDimensionHeight toSize:1.5f];
    
    [self.separationLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.separationLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.separationLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    
    /*-------------------*/
    
    if (self.constraintsFase == ABATextFieldConstraintsFaseLeft)
    {
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh
                 forConstraints:^
         {
             [self setLeftConstraints];
         }];
    }
    else if(self.constraintsFase == ABATextFieldConstraintsFaseRight)
    {
        [self setRightConstraints];
    }
}

- (void)setLeftConstraints
{
    [self.movablePlaceholder autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    self.movablePlaceholderAutoPinEdgeToSuperviewEdge = [self.movablePlaceholder autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                                                                       withInset:10.0f];
}

- (void)setRightConstraints
{
    [self.movablePlaceholder autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    self.movablePlaceholderAutoPinEdgeToSuperviewEdge = [self.movablePlaceholder autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                                                                  withInset:10.0f];
}

#pragma mark - Setters

- (void)setMovablePlaceholderText:(NSString *)movablePlaceholderText
{
    [self willChangeValueForKey:@"movablePlaceholderText"];
    _movablePlaceholderText = movablePlaceholderText;
    [self didChangeValueForKey:@"movablePlaceholderText"];
    
    self.movablePlaceholder.text = movablePlaceholderText;
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
    [self.movablePlaceholderAutoPinEdgeToSuperviewEdge autoRemove];

    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {

         [self setNeedsUpdateConstraints];
         [self layoutIfNeeded];
     }
                     completion:^(BOOL finished)
    {
        NSArray *array = self.constraints;
        NSLog(@"%lu", (unsigned long)[array count]);
        
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
