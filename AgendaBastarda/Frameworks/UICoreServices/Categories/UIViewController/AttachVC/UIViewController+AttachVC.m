//
//  UIViewController+Utilities.m
//  Fling
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIViewController+AttachVC.h"

@implementation UIViewController (AttachVC)

- (void)attachViewController:(UIViewController *)viewController{

    [viewController beginAppearanceTransition:YES animated:YES];
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController: viewController];
    [self.view addSubview: viewController.view];
    [viewController didMoveToParentViewController:self];

    [viewController endAppearanceTransition];
}

- (void)detachViewController:(UIViewController *)viewController {
    
    [viewController beginAppearanceTransition:NO animated:YES];
    
    [viewController.view removeFromSuperview];
    
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [viewController didMoveToParentViewController:nil];
    
    [viewController endAppearanceTransition];
}

@end
