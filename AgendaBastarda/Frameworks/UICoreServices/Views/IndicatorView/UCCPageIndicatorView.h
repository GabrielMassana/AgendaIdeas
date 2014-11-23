//
//  UCCIndicatorView.h
//  Fling
//
//  Created by James Campbell on 12/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCCPageIndicatorView;

/*!
 Used to define the orientation the indicator view should use to layout it's indicators.
 
 @since 1.0
 */
typedef NS_ENUM(NSUInteger, UCCPageIndicatorOrientation) {
    /*!
     Indicator view should layout it's indicators vertically.
     
     @since 1.0
     */
    UCCPageIndicatorOrientationVertical,
    /*!
     Indicator view should layout it's indicators horizontally.
     
     @since 1.0
     */
    UCCPageIndicatorOrientationHorizontal
};

/**
 *  The UCCPageIndicatorViewDataSource protocol is adopted by an object that mediates the application's data model for a UCCPageIndicatorView object. The data source provides the indicator-view object with the information it needs to construct and modify a indicator view.
 */
@protocol UCCPageIndicatorViewDataSource <NSObject>

@required

#pragma mark - Configuring a Indicator View
/**---------------------------------------------------------------------------------------
 * @name Configuring a Indicator View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Asks the data source to return the number of Pages for the indicator view.
 *
 *  @param pageIndicatorView An object representing the indicator view requesting this information.
 *
 *  @return The number of Pages.
 */
- (NSInteger)numberOfPagesForPageIndicatorView:(UCCPageIndicatorView *)pageIndicatorView;

/**
 *  Asks the data source to return the multiplier used to position each page being represented.
 *
 *  @param pageIndicatorView An object representing the indicator view requesting this information.
 *
 *  @return The multiplier for each axis.
 */
- (CGPoint)positionMultiplierForEachPageForPageIndicatorView:(UCCPageIndicatorView *)pageIndicatorView;

/**
 *  Asks the data source to return the content size of each Page for the indicator view.
 *
 *  @param pageIndicatorView An object representing the indicator view requesting this information.
 *
 *  @return The size of each Page.
 */
- (CGSize)contentSizeForEachPageForPageIndicatorView:(UCCPageIndicatorView *)pageIndicatorView;

/**
 *  Asks the data source to return the current content offset of the Pages for the inficator view.
 *
 *  @param pageIndicatorView An object representing the indicator view requesting this information.
 *
 *  @return The content offset of the Pages.
 */
- (CGPoint)contentOffsetForPageIndicatorView:(UCCPageIndicatorView *)pageIndicatorView;

@end

/**
 *  The delegate of a ViewControllerPageIndicatorView object must adopt the UCCPageIndicatorViewDelegate protocol.
 */
@protocol UCCPageIndicatorViewDelegate <NSObject>

@required

#pragma mark - Managing Selections
/**---------------------------------------------------------------------------------------
 * @name Managing Selections
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Tells the delegate that the specified indicator is now selected.
 *
 *  @param pageIndicatorView A indicator-view object informing the delegate about the new indicator selection.
 *  @param index             The index of the new selected indicator in indicatorView.
 */
- (void)pageIndicatorView:(UCCPageIndicatorView *)pageIndicatorView indicatorAtIndexWasSelected:(NSUInteger)index;

@end

/**
 *  UCCPageIndicatorView (or simply, a indicator view) is a means for creating and manage a series of indicators. Each indicator is rendered as a dot vertically positioned above each other, these correspond to an item of content. The current item of content is represented by a slightly bigger white dot. The dots animate with the current / non-current state based on the content offset, so makes for a nice effect when combined with scrollable content views, such as UIScrollView.
 
 For an example of a indicator view, see the Fling application on the Create a Fling screen.
 */
@interface UCCPageIndicatorView : UIView

#pragma mark - Managing the Delegate and the Data Source
/**---------------------------------------------------------------------------------------
 * @name Managing the Delegate and the Data Source
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The object that acts as the data source of the receiving indicator view.
 */
@property (nonatomic, weak) id<UCCPageIndicatorViewDataSource> dataSource;

/**
 *  The object that acts as the delegate of the receiving indicator view.
 */
@property (nonatomic, weak) id<UCCPageIndicatorViewDelegate> delegate;

/*!
 The orientation the indicator view should use to layout it's indicators.
 
 @since 1.0
 */
@property (nonatomic, assign) UCCPageIndicatorOrientation orientation;

/**
 *  Reloads the indicators of the receiver.
 */
- (void)reloadData;

@end
