//
//  UIViewController+Utilities.h
//  Fling
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AttachVC)

- (void)attachViewController:(UIViewController *)viewController;
- (void)detachViewController:(UIViewController *)viewController;

@end
