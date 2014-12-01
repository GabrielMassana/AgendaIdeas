//
//  GMATextField.m
//  AgendaBastarda
//
//  Created by GabrielMassana on 19/11/2014.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "GMATextField.h"
#import "NSObject+ABAAlphaColor.h"

typedef NS_ENUM(NSUInteger, GMATextFieldConstraintsFase)
{
    GMATextFieldConstraintsFaseDown = 0,
    GMATextFieldConstraintsFaseUp = 1,
};
@interface GMATextField ()

@property (nonatomic, strong) NSLayoutConstraint *movablePlaceholderAutoPinEdgeToSuperviewEdge;
@property (nonatomic, assign) GMATextFieldConstraintsFase constraintsFase;
@property (nonatomic, strong) UIView *separationLine;

@end

@implementation GMATextField

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
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
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
        _movablePlaceholder.textColor = [UIColor blueColor];
        _movablePlaceholder.alpha = 0.0;
//        [_movablePlaceholder sizeToFit];
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
    
    [self.separationLine autoSetDimension:ALDimensionHeight toSize:0.5f];
    
    [self.separationLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.separationLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [self.separationLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    
    /*-------------------*/
    
    if (self.constraintsFase == GMATextFieldConstraintsFaseDown)
    {
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh
                 forConstraints:^
         {
             [self setBottomConstraints];
         }];
    }
    else if(self.constraintsFase == GMATextFieldConstraintsFaseUp)
    {
        [self setTopConstraints];
    }
}

- (void)setBottomConstraints
{
    [self.movablePlaceholder autoSetDimensionsToSize:self.frame.size];
    self.movablePlaceholderAutoPinEdgeToSuperviewEdge = [self.movablePlaceholder autoPinEdge:ALEdgeBottom
                                                                                      toEdge:ALEdgeBottom
                                                                                      ofView:self
                                                                                  withOffset:0.0f];
    
    [self.movablePlaceholder autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                              withInset:10.0f];
}

- (void)setTopConstraints
{

    [self.movablePlaceholder autoSetDimensionsToSize:self.frame.size];
    
    self.movablePlaceholderAutoPinEdgeToSuperviewEdge = [self.movablePlaceholder autoPinEdge:ALEdgeBottom
                                                                                      toEdge:ALEdgeTop
                                                                                      ofView:self
                                                                                  withOffset:40.0f];
    [self.movablePlaceholder autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                              withInset:10.0f];
}

#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    self.movablePlaceholder.text = placeholder;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
//    self.movablePlaceholder.textColor = [self.textColor aba_newColorForPlaceholder];
    [[UITextField appearance] setTintColor:textColor];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.movablePlaceholder.font = [UIFont fontWithName:self.movablePlaceholder.font.familyName size:self.movablePlaceholder.font.pointSize - 2];
    
}

#pragma mark - Notifications

- (void)textDidBeginEditing
{
}

- (void)textDidChange
{
    NSUInteger textLength = self.text.length;
    
    if (textLength == 0)
    {
        self.constraintsFase = GMATextFieldConstraintsFaseDown;
        [self animatePlaceholderWithAplha:0.0f];

    }
    else
    {
        self.constraintsFase = GMATextFieldConstraintsFaseUp;
        [self animatePlaceholderWithAplha:1.0f];

    }
    

}

- (void)textDidEndEditing
{
//    NSInteger textLength = self.text.length;
//    
//    if (textLength == 0)
//    {
//        self.constraintsFase = GMATextFieldConstraintsFaseDown;
//        [self animatePlaceholderWithAplha:0.0f];
//    }
}

#pragma mark - Animations

- (void)animatePlaceholderWithAplha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.movablePlaceholder.alpha = alpha;
         
         [self.movablePlaceholderAutoPinEdgeToSuperviewEdge autoRemove];
         
         [self setNeedsUpdateConstraints];
         [self layoutIfNeeded];
     }
                     completion:nil];
}

#pragma mark - TextPosition

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,
                       10,
                       0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
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


#pragma mark - MemoryManagement

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
