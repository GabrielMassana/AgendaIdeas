//
//  UUCSegmentedViewController.m
//  Unii
//
//  Created by James Campbell on 08/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UUCSegmentedViewController.h"

@implementation UIViewController (UUCSegmentedViewController)

#pragma mark - SegmentViewController

- (UUCSegmentedViewController *)segmentViewController
{
    
    UIViewController *viewController = self.parentViewController;
    
    if ( ![viewController isKindOfClass:[UUCSegmentedViewController class]] ) {
        
        viewController = viewController.segmentViewController;
    }
    
    return (UUCSegmentedViewController *)viewController;
}

@end

@interface UUCSegmentedViewController ()

@property (nonatomic, strong, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) UIView *badgeContainer;

- (UIImageView *)createBadgeForIndex:(NSUInteger)index;

- (void)segmentControlChanged:(id)sender;
- (void)adjustScrollInsetForViewController:(UIViewController *)viewController;

@end

@implementation UUCSegmentedViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    
    self = [self init];
    
    if (  self )
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.viewControllers = viewControllers;
        self.navigationItem.titleView = self.segmentControl;
        self.navigationItem.titleView.frame = self.segmentControl.frame;
        
        self.badges = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < viewControllers.count; i++)
        {
            [self.badges addObject:[NSNull null]];
        }
    }
    
    return self;
}

#pragma mark - ViewLifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [self adjustScrollInsetForViewController: self.currentViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    [self adjustScrollInsetForViewController: self.currentViewController];
    
    /*-----------------*/
    
    [self.badgeContainer removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self.navigationController.navigationBar addSubview:self.badgeContainer];
}

#pragma mark - SegmentControl

- (UISegmentedControl *)segmentControl {
    
    if ( !_segmentControl )
    {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:[self.viewControllers valueForKey:@"title"]];
        
        [self showViewControllerAtIndex: 0];
        [_segmentControl addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (void)segmentControlChanged:(UISegmentedControl *)sender {
    
    [self showViewControllerAtIndex: sender.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSInteger)index {
    
    self.segmentControl.selectedSegmentIndex = index;
    
    UIViewController *newViewController = self.viewControllers[index];
    
    if ( newViewController != self.currentViewController )
    {
        [self.currentViewController willMoveToParentViewController: nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController didMoveToParentViewController: nil];
    }
    
    newViewController.view.frame = self.view.frame;
    
    [self addChildViewController: newViewController];
    [newViewController beginAppearanceTransition:YES animated:NO];
    [self.view addSubview: newViewController.view];
    [newViewController endAppearanceTransition];
    
    if ( newViewController.automaticallyAdjustsScrollViewInsets )
    {
        [self adjustScrollInsetForViewController: newViewController];
    }
    
    self.currentViewController = newViewController;
}

- (void)adjustScrollInsetForViewController:(UIViewController *)viewController {
    
    UIScrollView *view = [viewController.view.subviews firstObject];
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    insets.top += navigationBar.frame.size.height + statusBarFrame.size.height;
    insets.bottom += tabBar.frame.size.height;
    
    view.contentInset = insets;
    
}

#pragma mark - SubViews

- (UIView *)badgeContainer
{
    
    if (!_badgeContainer)
    {
        
        _badgeContainer = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
        _badgeContainer.userInteractionEnabled = NO;
    }
    
    return _badgeContainer;
}

- (UIImageView *)createBadgeForIndex:(NSUInteger)index
{
    UIImageView *badgeView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"notification-badge"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    if ((index + 1) == self.viewControllers.count)
    {
        index += 1;
    }
    
    badgeView.frame = CGRectMake(-5.0f, -5.0f, 15.0f, 15.0f);
    badgeView.frame = CGRectOffset(badgeView.frame, index * (self.segmentControl.frame.size.width / self.segmentControl.numberOfSegments), 0.0f);
    
    [self.badgeContainer addSubview: badgeView];
    
    return badgeView;
}

- (void)setBadgeShown:(BOOL)shown forViewControllerAtIndex:(NSUInteger)index
{
    
    UIImageView *badge = [self.badges objectAtIndex: index];
    
    if ((id)badge == [NSNull null] && shown)
    {
        badge = [self createBadgeForIndex: index];
        [self.badges setObject:badge atIndexedSubscript:index];
    }
    else if ((id)badge != [NSNull null] && !shown)
    {
        [badge removeFromSuperview];
        badge = nil;
        [self.badges setObject:[NSNull null] atIndexedSubscript:index];
    }
    
}


@end
