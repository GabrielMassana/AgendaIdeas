//
//  UUCSegmentedViewController.h
//  Unii
//
//  Created by James Campbell on 08/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUCSegmentedViewController;

@interface UIViewController (UUCSegmentedViewController)

- (UUCSegmentedViewController *)segmentViewController;

@end

@interface UUCSegmentedViewController : UIViewController

@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, readonly) UISegmentedControl *segmentControl;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)showViewControllerAtIndex:(NSInteger)index;
- (void)setBadgeShown:(BOOL)shown forViewControllerAtIndex:(NSUInteger)index;

@end
