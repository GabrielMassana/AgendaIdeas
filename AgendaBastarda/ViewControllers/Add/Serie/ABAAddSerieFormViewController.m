//
//  ABAAddSerieFormViewController.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 14/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddSerieFormViewController.h"
#import "ABATextField.h"
#import "ABAFont.h"
#import "GMATextField.h"


@interface ABAAddSerieFormViewController ()

@property (nonatomic, strong) ABATextField *nameTextField;
@property (nonatomic, strong) ABATextField *startsTextField;
@property (nonatomic, strong) GMATextField *someTextField;

@end

@implementation ABAAddSerieFormViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.startsTextField];
    [self.view addSubview:self.someTextField];

    [self updateViewConstraints];
}

#pragma mark - Subviews

- (ABATextField *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [ABATextField newAutoLayoutView];
        _nameTextField.font = [ABAFont openSansRegularFontWithSize:20.0f];
        _nameTextField.placeholder = @"Email";
        _nameTextField.textColor = [UIColor blackColor];
    }
    
    return _nameTextField;
}

- (ABATextField *)startsTextField
{
    if (!_startsTextField)
    {
        _startsTextField = [ABATextField newAutoLayoutView];
        _startsTextField.font = [ABAFont openSansRegularFontWithSize:20.0f];
        _startsTextField.placeholder = @"Password";
        _startsTextField.textColor = [UIColor blackColor];
    }
    
    return _startsTextField;
}

- (GMATextField *)someTextField
{
    if (!_someTextField)
    {
        _someTextField = [GMATextField newAutoLayoutView];
        _someTextField.font = [ABAFont openSansRegularFontWithSize:20.0f];
        _someTextField.placeholder = @"Placeholder";
        _someTextField.textColor = [UIColor blackColor];
    }
    
    return _someTextField;
}

#pragma mark - Constraints

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    /*-------------------*/

    [self.nameTextField autoSetDimension:ALDimensionHeight
                                  toSize:60.0f];
    
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                         withInset:0.0f];
    
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeRight
                                         withInset:0.0f];
    
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeTop
                                         withInset:64.0f];
    
    /*-------------------*/

    [self.startsTextField autoSetDimension:ALDimensionHeight
                                  toSize:60.0f];
    
    [self.startsTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                           withInset:0.0f];
    
    [self.startsTextField autoPinEdgeToSuperviewEdge:ALEdgeRight
                                           withInset:0.0f];
    
    [self.startsTextField autoPinEdge:ALEdgeTop
                               toEdge:ALEdgeBottom
                               ofView:self.nameTextField];
    
    /*-------------------*/
    
    [self.someTextField autoSetDimension:ALDimensionHeight
                                  toSize:60.0f];
    
    [self.someTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                         withInset:0.0f];
    
    [self.someTextField autoPinEdgeToSuperviewEdge:ALEdgeRight
                                         withInset:0.0f];
    
    [self.someTextField autoPinEdge:ALEdgeTop
                             toEdge:ALEdgeBottom
                             ofView:self.startsTextField
                         withOffset:0.0f];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
