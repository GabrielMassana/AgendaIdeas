//
//  UCCNavigationBar.h
//  Fling
//
//  Created by James Campbell on 01/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Defines the rendering style of the navigation bar

 */
typedef NS_ENUM(NSUInteger, UCCNavigationBarBackgroundStyle) {
    /*!
     Navigation bar should render using its background in full color.
     */
    UCCNavigationBarBackgroundStyleOpaqueColor,
    /*!
     Navigation Bar should render with totally transparent background.
     */
    UCCNavigationBarBackgroundStyleTransparent
};

/*!
 This is a custom navigation bar we use, so that we can have it appear without a background. It is used heavily on the create a fling screens.

 */
@interface UCCNavigationBar : UINavigationBar

@property (nonatomic, assign) UCCNavigationBarBackgroundStyle backgroundStyle;

- (void)setBackgroundStyle:(UCCNavigationBarBackgroundStyle)backgroundStyle animated:(BOOL)animated;

@end
