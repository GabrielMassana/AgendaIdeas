//
//  ABAAddNameCollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddNameCollectionViewCell.h"
#import "ABATextField.h"
#import "ABAFont.h"
#import "ABAColor.h"

@interface ABAAddNameCollectionViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) ABAAddSerieCell *addSerieCell;

@end

@implementation ABAAddNameCollectionViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setupView
{
    self.contentView.backgroundColor = [ABAColor lightLightGrayColor];
    [self.contentView addSubview:self.textField];
}

#pragma mark - Subviews

- (ABATextField *)textField
{
    if (!_textField)
    {
        _textField = [ABATextField newAutoLayoutView];
        _textField.placeholder = @"Name";
        _textField.font = [ABAFont openSansSemiboldFontWithSize:20.0f];
        _textField.textColor = [UIColor blackColor];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    
    return _textField;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*---------------------*/
    
    [self.textField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f,
                                                                            0.0f,
                                                                            0.0f,
                                                                            0.0f)];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.textField resignFirstResponder];
    }
    
    return YES;
}

- (void)updateWithAddSerieCellData:(ABAAddSerieCell *)addSerieCell
{
    self.addSerieCell = addSerieCell;
    self.key = addSerieCell.key;
    self.textField.autocapitalizationType = addSerieCell.autocapitalizationType;
    self.textField.autocorrectionType = addSerieCell.autocorrectType;
    self.textField.placeholder = addSerieCell.placeholder;
    self.textField.returnKeyType = addSerieCell.returnKeyType;
    
}
@end

