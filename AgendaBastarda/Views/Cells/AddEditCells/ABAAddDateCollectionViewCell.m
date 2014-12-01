//
//  ABAAddDateCollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddDateCollectionViewCell.h"
#import "ABATextFieldDate.h"
#import "ABAFont.h"

@interface ABAAddDateCollectionViewCell () <UITextFieldDelegate>

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *inputToolbar;
@property (nonatomic, strong) UIBarButtonItem *toolbarDoneButton;

@property (nonatomic, strong) ABAAddSerieCell *addSerieCell;

@end

@implementation ABAAddDateCollectionViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textField];
    
    self.textField.inputAccessoryView = self.inputToolbar;
    self.textField.inputView = self.datePicker;
}

- (UIBarButtonItem *)toolbarDoneButton
{
    if (!_toolbarDoneButton)
    {
        _toolbarDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(toolbarDoneButtonPressed:)];
    }
    
    return _toolbarDoneButton;
}

#pragma mark - Subviews

- (ABATextFieldDate *)textField
{
    if (!_textField)
    {
        _textField = [ABATextFieldDate newAutoLayoutView];
        _textField.font = [ABAFont openSansRegularFontWithSize:14.0f];
        _textField.textColor = [UIColor blackColor];
        _textField.delegate = self;
//        _textField.returnKeyType = UIReturnKeyNext;
    }
    
    return _textField;
}

- (UIToolbar *)inputToolbar
{
    if (!_inputToolbar)
    {
        UIBarButtonItem *spacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:nil
                                                                                     action:nil];
        
        _inputToolbar = [[UIToolbar alloc] init];
        _inputToolbar.items = @[spacingItem, self.toolbarDoneButton];
        
        [_inputToolbar sizeToFit];
    }
    
    return _inputToolbar;
}

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return dateFormatter;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self
                        action:@selector(dateDidChanged:)
              forControlEvents:UIControlEventValueChanged];
    }
    
    return _datePicker;
}

- (void)dateDidChanged:(UIDatePicker *)datePicker
{
    self.textField.text = [self.dateFormatter stringFromDate:datePicker.date];
    [self.textField textDidChange];
//    self.textField.placeholder = @"";
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

#pragma mark - ButtonActions

- (void)toolbarDoneButtonPressed:(UIBarButtonItem *)doneButton
{
    self.textField.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    [self.textField textDidChange];
//    self.textField.placeholder = @"";
    
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [textField resignFirstResponder];
}

- (void)updateWithAddSerieCellData:(ABAAddSerieCell *)addSerieCell
{
    self.addSerieCell = addSerieCell;
    self.key = addSerieCell.key;
    self.textField.autocapitalizationType = addSerieCell.autocapitalizationType;
    self.textField.autocorrectionType = addSerieCell.autocorrectType;
    self.textField.placeholder = addSerieCell.placeholder;
    self.textField.returnKeyType = addSerieCell.returnKeyType;
    
    if (addSerieCell.returnKeyType == UIReturnKeyNext)
    {
        self.toolbarDoneButton.title = @"Next";
    }
}

@end

