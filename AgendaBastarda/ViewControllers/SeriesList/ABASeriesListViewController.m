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
#import "ABAAppDelegate.h"
#import "ABASerie.h"

typedef NS_ENUM(NSUInteger, ABAConstraintsFase)
{
    ABAConstraintsFaseUnknown = 0,
    ABAConstraintsFaseUp = 1,
    ABAConstraintsFaseDown = 2,
};

static CGFloat const kCellHeightSize = 150.0f;

static CGFloat const kButtonSize = 90.0f;

@interface ABASeriesListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ABASerieCollectionViewCellDelegate, NSFetchedResultsControllerDelegate>

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

@property (nonatomic, strong) ABAAppDelegate *appDelegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) ABAAddSerieFormViewController *addSerieFormViewController;
@property (nonatomic, assign) CGPoint gestureRecognizerLastLocation;

/**
 Used to connect the CollectionView with Core Data.
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSMutableArray *sectionChanges;
@property (nonatomic, strong) NSMutableArray *itemChanges;

@end

@implementation ABASeriesListViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (ABAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.gestureRecognizerLastLocation = CGPointZero;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.serieButton];
    [self.view addSubview:self.filmButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addNewSerieButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingsButton];
    
    [self setUpConstraint];
    
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBarsOnSwipe = YES;
    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
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

#pragma mark - Getters

- (ABAAddSerieFormViewController *)addSerieFormViewController
{
    if (!_addSerieFormViewController)
    {
        _addSerieFormViewController = [[ABAAddSerieFormViewController alloc] initWithViewControllerType:ABAAddSerieFilmTypeViewControllerEdit];
    }
    
    return _addSerieFormViewController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        ABAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;

        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ABASerie class])
                                          inManagedObjectContext:self.managedObjectContext];
        
        NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start"
                                                                              ascending:YES];
        fetchRequest.sortDescriptors = @[orderSortDescriptor];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
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
    self.navigationController.hidesBarsOnSwipe = NO;

    [self animateButtonsWithFinalAlpha:1.0f];
}

- (void)addNewSerieButtonTouchUpInside:(UIButton *)sender withEvent:(UIEvent *)event
{
    self.constraintsFase = ABAConstraintsFaseUp;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self checkTouchPoint:touchPoint];
    
    [self animateButtonsWithFinalAlpha:0.0f];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)addNewSerieButtonTouchUpOutside:(UIButton *)sender withEvent:(UIEvent *)event
{
    self.constraintsFase = ABAConstraintsFaseUp;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self checkTouchPoint:touchPoint];
    
    [self animateButtonsWithFinalAlpha:0.0f];
    self.navigationController.hidesBarsOnSwipe = YES;
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

#pragma mark - AddController

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
    ABAAddSerieFormViewController *addSerieFormViewController = [[ABAAddSerieFormViewController alloc] initWithViewControllerType:ABAAddSerieFilmTypeViewControllerSave];
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
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ABASerieCollectionViewCell *cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ABASerieCollectionViewCell reuseIdentifier]
                                                     forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell updateWithPersistentSerieCellData:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    cell.tag = indexPath.row;
    
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

#pragma mark - UICollectionViewDelegate


#pragma mark - ABASerieCollectionViewCellDelegate

- (void)longPressGestureRecognizerShouldBegin:(UIGestureRecognizer *)sender cell: (ABASerieCollectionViewCell *) cell
{
    NSLog(@"longPressGestureRecognizerShouldBegin");
    
    [self addChildViewController:self.addSerieFormViewController];
    self.addSerieFormViewController.view.frame = [[UIScreen mainScreen] bounds];

    [self.addSerieFormViewController updateWithSerie:cell.serie];
    
    [self.view addSubview:self.addSerieFormViewController.view];
    self.navigationController.navigationBar.hidden = YES;

    [self.addSerieFormViewController didMoveToParentViewController:self];
}

- (void)longPressGestureRecognizerChanged:(UIGestureRecognizer *)sender cell: (ABASerieCollectionViewCell *) cell;
{
    NSLog(@"longPressGestureRecognizerChanged");
    
    CGPoint location = [sender locationInView:self.appDelegate.window];
    
    NSLog(@"location = %@", NSStringFromCGPoint(location));
    
    //Store last location
    self.gestureRecognizerLastLocation = location;
}

- (void)longPressGestureRecognizerEnded
{
    NSLog(@"longPressGestureRecognizerEnded");
    
    [self.addSerieFormViewController willMoveToParentViewController:nil];
    [self.addSerieFormViewController.view removeFromSuperview];
    [self.addSerieFormViewController removeFromParentViewController];
    self.navigationController.navigationBar.hidden = NO;

    // Check if location is over Edit Button, if yes open it
    if (CGRectContainsPoint(self.addSerieFormViewController.finishButton.frame, self.gestureRecognizerLastLocation))
    {
        [self pushAddSerieViewControllerAnimated:NO];
        self.gestureRecognizerLastLocation = CGPointZero;

    }
//    self.addSerieFormViewController = nil;
}

#pragma mark - NSFetchedResultsControllerDelegate
// http://samwize.com/2014/07/07/implementing-nsfetchedresultscontroller-for-uicollectionview/
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.sectionChanges = [[NSMutableArray alloc] init];
    self.itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    
    change[@(type)] = @(sectionIndex);
    
    [self.sectionChanges addObject:change];
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath;
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            
            change[@(type)] = newIndexPath;
            
            break;
        case NSFetchedResultsChangeDelete:
            
            change[@(type)] = indexPath;
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            change[@(type)] = indexPath;
            
            break;
        case NSFetchedResultsChangeMove:
                        
            change[@(type)] = @[indexPath, newIndexPath];
            
            break;
    }
    
    [self.itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView performBatchUpdates:^
    {
        for (NSDictionary *change in self.sectionChanges)
        {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
            {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type)
                {
                    case NSFetchedResultsChangeInsert:
                        
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    
                    case NSFetchedResultsChangeDelete:
                        
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    
                    default:
                        break;
                }
            }];
        }
        for (NSDictionary *change in self.itemChanges)
        {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
            {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type)
                {
                    case NSFetchedResultsChangeInsert:
                        
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                        
                    case NSFetchedResultsChangeDelete:
                        
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                        
                    case NSFetchedResultsChangeUpdate:
                        
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                        
                    case NSFetchedResultsChangeMove:
                        
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    }
                                  completion:^(BOOL finished) {
                                      
        self.sectionChanges = nil;
        self.itemChanges = nil;
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end