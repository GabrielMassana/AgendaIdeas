//
//  ABAAddFilmFormViewController.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 19/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddFilmFormViewController.h"

@implementation ABAAddFilmFormViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self updateViewConstraints];
}

@end
