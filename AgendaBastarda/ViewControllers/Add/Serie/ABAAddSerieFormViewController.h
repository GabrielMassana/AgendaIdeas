//
//  ABAAddSerieFormViewController.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 14/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABASerie;

typedef NS_ENUM(NSUInteger, ABAAddSerieFilmTypeViewController)
{
    ABAAddSerieFilmTypeViewControllerSave  = 0,
    ABAAddSerieFilmTypeViewControllerEdit  = 1,
};

@interface ABAAddSerieFormViewController : UIViewController

- (instancetype)initWithViewControllerType:(ABAAddSerieFilmTypeViewController)typeViewController;

@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, assign) ABAAddSerieFilmTypeViewController typeViewController;

- (void)updateWithSerie:(ABASerie *)serie;

@end
