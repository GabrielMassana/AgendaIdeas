//
//  ViewController.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 14/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABASeriesListViewController.h"
#import "ABASerieCollectionViewCell.h"
#import "ABAAddSerieFormViewController.h"
#import "ABAAddFilmFormViewController.h"

typedef NS_ENUM(NSUInteger, ABAConstraintsFase)
{
    ABAConstraintsFaseUnknown = 0,
    ABAConstraintsFaseUp = 1,
    ABAConstraintsFaseDown = 2,
};

static CGFloat const kCellHeightSize = 150.0f;

static CGFloat const kButtonSize = 90.0f;

@interface ABASeriesListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *addNewSerieButton;
@property (nonatomic, strong) UIButton *settingsButton;

@property (nonatomic, strong) UIButton *serieButton;
@property (nonatomic, strong) UIButton *filmButton;

@property (nonatomic, strong) NSLayoutConstraint *serieButtonSizeConstraintWidth;
@property (nonatomic, strong) NSLayoutConstraint *serieButtonSizeConstraintHeight;
@property (nonatomic, strong) NSLayoutConstraint *serieButtonSizeConstraintTop;
@property (nonatomic, strong) NSLayoutConstraint *serieButtonSizeConstraintRight;

@property (nonatomic, strong) NSLayoutConstraint *filmButtonSizeConstraintWidth;
@property (nonatomic, strong) NSLayoutConstraint *filmButtonSizeConstraintHeight;
@property (nonatomic, strong) NSLayoutConstraint *filmButtonSizeConstraintTop;
@property (nonatomic, strong) NSLayoutConstraint *filmButtonSizeConstraintRight;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) ABAConstraintsFase constraintsFase;

/**
 Used to connect the CollectionView with Core Data.
 */
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ABASeriesListViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.serieButton];
    [self.view addSubview:self.filmButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addNewSerieButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingsButton];
    
    [self setUpConstraint];
    
    [self updateViewConstraints];
}

//http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes

#pragma mark - Subviews

- (UIButton *)addNewSerieButton
{
    if (!_addNewSerieButton)
    {
        _addNewSerieButton = [UIButton newAutoLayoutView];
        _addNewSerieButton.backgroundColor = [UIColor redColor];
        _addNewSerieButton.frame = CGRectMake(0, 0, 50, 30);
        [_addNewSerieButton addTarget:self action:@selector(addNewSerieButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_addNewSerieButton addTarget:self action:@selector(addNewSerieButtonTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_addNewSerieButton addTarget:self action:@selector(addNewSerieButtonTouchUpOutside:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    }
    
    return _addNewSerieButton;
}

- (UIButton *)settingsButton
{
    if (!_settingsButton)
    {
        _settingsButton = [UIButton newAutoLayoutView];
        _settingsButton.backgroundColor = [UIColor blueColor];
        _settingsButton.frame = CGRectMake(50, 30, 50, 30);
    }
    
    return _settingsButton;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing = 0.0f;
        layout.sectionInset = UIEdgeInsetsMake(0.0f,
                                               0.0f,
                                               0.0f,
                                               0.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.view.bounds.size.width,
                                                                             self.view.bounds.size.height)
                                             collectionViewLayout:layout];
        
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self registerCells];
    }
    
    return _collectionView;
}

- (UIButton *)serieButton
{
    if (!_serieButton)
    {
        _serieButton = [UIButton new];
        _serieButton.translatesAutoresizingMaskIntoConstraints = NO;
        _serieButton.alpha = 0.0f;
        [_serieButton setBackgroundImage:[UIImage imageNamed:@"series_icon"] forState:UIControlStateNormal];  //TV icon +
    }
    
    return _serieButton;
}

- (UIButton *)filmButton
{
    if (!_filmButton)
    {
        _filmButton = [UIButton new];
        _filmButton.translatesAutoresizingMaskIntoConstraints = NO;
        _filmButton.alpha = 0.0f;
        [_filmButton setBackgroundImage:[UIImage imageNamed:@"film_icon"] forState:UIControlStateNormal];  //Film icon +
        
    }
    
    return _filmButton;
}

#pragma mark - Constraints

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.constraintsFase == ABAConstraintsFaseUnknown)
    {
        [self.serieButton addConstraint:self.serieButtonSizeConstraintWidth];
        
        [self.serieButton addConstraint:self.serieButtonSizeConstraintHeight];
        
        [self.view addConstraint:self.serieButtonSizeConstraintTop];
        
        [self.view addConstraint:self.serieButtonSizeConstraintRight];
        
        /*-------------------*/
        
        [self.filmButton addConstraint:self.filmButtonSizeConstraintWidth];
        
        [self.filmButton addConstraint:self.filmButtonSizeConstraintHeight];
        
        [self.view addConstraint:self.filmButtonSizeConstraintTop];
        
        [self.view addConstraint:self.filmButtonSizeConstraintRight];
    }
}

- (void)setUpConstraint
{
    self.serieButtonSizeConstraintWidth = [NSLayoutConstraint constraintWithItem:self.serieButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    self.serieButtonSizeConstraintHeight = [NSLayoutConstraint constraintWithItem:self.serieButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    self.serieButtonSizeConstraintTop =[NSLayoutConstraint constraintWithItem:self.serieButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:64.0];
    
    self.serieButtonSizeConstraintRight = [NSLayoutConstraint constraintWithItem:self.serieButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-45.0];
    
    /*-------------------*/
    
    self.filmButtonSizeConstraintWidth = [NSLayoutConstraint constraintWithItem:self.filmButton
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    self.filmButtonSizeConstraintHeight = [NSLayoutConstraint constraintWithItem:self.filmButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    self.filmButtonSizeConstraintTop =[NSLayoutConstraint constraintWithItem:self.filmButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:64.0];
    
    self.filmButtonSizeConstraintRight = [NSLayoutConstraint constraintWithItem:self.filmButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-45.0];
}

#pragma mark - ButtonActions

- (void)addNewSerieButtonTouchDown:(UIButton *)sender
{
    self.constraintsFase = ABAConstraintsFaseDown;
    
    [self animateButtonsWithFinalAlpha:1.0f];
}

- (void)addNewSerieButtonTouchUpInside:(UIButton *)sender withEvent:(UIEvent *)event
{
    self.constraintsFase = ABAConstraintsFaseUp;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self checkTouchPoint:touchPoint];
    
    [self animateButtonsWithFinalAlpha:0.0f];
}

- (void)addNewSerieButtonTouchUpOutside:(UIButton *)sender withEvent:(UIEvent *)event
{
    self.constraintsFase = ABAConstraintsFaseUp;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self checkTouchPoint:touchPoint];
    
    [self animateButtonsWithFinalAlpha:0.0f];
}

- (void)animateButtonsWithFinalAlpha:(CGFloat)alpha
{
    [self.view layoutIfNeeded];
    
    if (self.constraintsFase == ABAConstraintsFaseUp)
    {
        self.serieButtonSizeConstraintWidth.constant = 0.0f;
        self.serieButtonSizeConstraintHeight.constant = 0.0f;
        self.serieButtonSizeConstraintTop.constant = 64.0f;
        self.serieButtonSizeConstraintRight.constant = -45.0f;
        
        /*-------------------*/
        
        self.filmButtonSizeConstraintWidth.constant = 0.0f;
        self.filmButtonSizeConstraintHeight.constant = 0.0f;
        self.filmButtonSizeConstraintTop.constant = 64.0f;
        self.filmButtonSizeConstraintRight.constant = -45.0f;
    }
    else if(self.constraintsFase == ABAConstraintsFaseDown)
    {
        self.serieButtonSizeConstraintWidth.constant = kButtonSize;
        self.serieButtonSizeConstraintHeight.constant = kButtonSize;
        self.serieButtonSizeConstraintTop.constant = 64.0f;
        self.serieButtonSizeConstraintRight.constant = -90.0f;
        
        /*-------------------*/
        
        self.filmButtonSizeConstraintWidth.constant = kButtonSize;
        self.filmButtonSizeConstraintHeight.constant = kButtonSize;
        self.filmButtonSizeConstraintTop.constant = 105.0f;
        self.filmButtonSizeConstraintRight.constant = 0.0f;
    }
    
    [UIView animateWithDuration:0.25
                     animations:^
     {
         self.serieButton.alpha = alpha;
         self.filmButton.alpha = alpha;
         
         [self.view layoutIfNeeded];
     }
     
                     completion:^(BOOL finished)
     
     {
     }];
}

#pragma mark AddController

- (void)checkTouchPoint:(CGPoint)touchPoint
{
    if (CGRectContainsPoint(self.serieButton.frame, touchPoint))
    {
        [self  pushAddSerieViewControllerAnimated:YES];
    }
    else if (CGRectContainsPoint(self.filmButton.frame, touchPoint))
    {
        [self  pushAddFilmViewControllerAnimated:YES];
    }
}

- (void) pushAddSerieViewControllerAnimated:(BOOL)animated
{
    ABAAddSerieFormViewController *addSerieFormViewController = [[ABAAddSerieFormViewController alloc] init];
    [self.navigationController pushViewController:addSerieFormViewController animated:animated];
}

- (void) pushAddFilmViewControllerAnimated:(BOOL)animated
{
    ABAAddFilmFormViewController *addFilmFormViewController = [[ABAAddFilmFormViewController alloc] init];
    [self.navigationController pushViewController:addFilmFormViewController animated:animated];
}

#pragma mark - RegisterCells

- (void)registerCells
{
    [self.collectionView registerClass:[ABASerieCollectionViewCell class]
            forCellWithReuseIdentifier:[ABASerieCollectionViewCell reuseIdentifier]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return [self.fetchedResultsController.fetchedObjects count];
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABASerieCollectionViewCell *cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABASerieCollectionViewCell reuseIdentifier]
                                                     forIndexPath:indexPath];
    
    //    [cell updateWithFling:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    
    /*---------------------*/
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    /*---------------------*/
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,
                      kCellHeightSize);
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end