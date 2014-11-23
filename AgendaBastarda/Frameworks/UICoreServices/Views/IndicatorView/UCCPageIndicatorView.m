//
//  UCCPageIndicatorView.m
//  Fling
//
//  Created by James Campbell on 12/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UCCPageIndicatorView.h"

//Constants Used For Indicators
#define MAX_DIAMETER 16
#define MIN_DIAMETER 8
#define DIAMETER_DIFF MAX_DIAMETER - MIN_DIAMETER

#define INDICATOR_PADDING 12
#define INDICATOR_START_OFFSET 5
#define EDGE_PADDING 4.0

/**
 *  IndicatorLayer provides the rendering of the indicators used in the Indicator View.
 */
@interface IndicatorLayer : CALayer

/**
 *  The scale of the IndicatorLayer. This is also used to determine the alpha of its fill color as it gets bigger.
 */
@property (nonatomic, assign) float scale;

@end

@implementation IndicatorLayer

-(instancetype) init {
    
    self = [super init];
    
    self.allowsEdgeAntialiasing = YES;
    self.bounds = CGRectMake(0, 0, MAX_DIAMETER + (EDGE_PADDING * 2), MAX_DIAMETER + (INDICATOR_PADDING * 2));
    self.contentsScale = [UIScreen mainScreen].scale;
    self.drawsAsynchronously = YES;
    
    [self setNeedsDisplay];
    
    return self;
}

- (void)setScale:(float)scale {
    
    if ( scale != self.scale ) {
        
        _scale = scale;
        [self setNeedsDisplay];
        
    }
}

- (void)drawInContext:(CGContextRef)theContext
{
    
    CGContextBeginPath(theContext);
    
    //The bigger the scale the bigger the circle - that's kind of what scale does.
    float circleDiameter = MAX_DIAMETER - ( ( MIN_DIAMETER / 100.0 ) * self.scale );
    CGPoint circleCenter = CGPointMake( CGRectGetMidX(self.bounds) , CGRectGetMidY(self.bounds) );
    
    //Circle
    CGContextBeginPath(theContext);
    
    CGContextAddArc(theContext, circleCenter.x, circleCenter.y, circleDiameter / 2, 0, 2 * M_PI, 0);
    
    CGContextSetLineWidth(theContext, 1);
    CGContextSetStrokeColorWithColor(theContext, [UIColor whiteColor].CGColor);
    
    //Make Circle's Fill Color get less transparent the bigger the scale.
    CGContextSetFillColorWithColor(theContext, [UIColor colorWithWhite:1.0 alpha:1.0f - (self.scale / 100.0f)].CGColor);
    
    CGContextClosePath(theContext);
    CGContextDrawPath(theContext, kCGPathFillStroke);
    
    
    //Black Line - Used As Border For Contrast Around Circle
    CGContextBeginPath(theContext);
    
    CGContextAddArc(theContext, circleCenter.x, circleCenter.y, (circleDiameter / 2) + 1, 0, 2 * M_PI, 0);
    
    CGContextSetLineWidth(theContext, 1);
    CGContextSetStrokeColorWithColor(theContext, [UIColor colorWithWhite:0.0 alpha:0.3f].CGColor);
    
    CGContextClosePath(theContext);
    CGContextDrawPath(theContext, kCGPathStroke);
}

@end

@interface UCCPageIndicatorView ()

/**
 *  An Array of all the IndicatorLayers used to render the indicators in the view.
 */
@property (nonatomic, strong) NSMutableArray * indicatorLayers;

- (void)initilize;

/**
 *  Updates all the IndicatorLayers contained within this view.
 *
 *  @param layer The layer to used by this view for the update of the IndicatorLayers.
 */
- (void)updateIndicators:(CALayer *)layer;

/**
 *  Updates the number of IndicatorLayers to reflect the number provided to the view by it's data source.
 *
 */
- (void)updateNumberOfIndicators;

@end

@implementation UCCPageIndicatorView

#pragma mark - Superclass

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ( self = [super initWithFrame:frame] ) {
        
        [self initilize];
        
        self.layer.delegate = self;
    }
    
    return self;
}

- (NSMutableArray *)indicatorLayers {
    
    if ( !_indicatorLayers ) {
        
        _indicatorLayers = [[NSMutableArray alloc] init];
    }
    
    return _indicatorLayers;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [self updateNumberOfIndicators];
    [self updateIndicators:layer];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    float totalIndicatorSize = (MAX_DIAMETER + INDICATOR_PADDING) * [self.dataSource numberOfPagesForPageIndicatorView: self];
    
    if ( self.orientation == UCCPageIndicatorOrientationVertical ) {
        
        return CGSizeMake(MAX_DIAMETER + EDGE_PADDING, totalIndicatorSize);
        
    } else {
        
        return CGSizeMake(totalIndicatorSize, MAX_DIAMETER + EDGE_PADDING);
        
    }
    
}

#pragma mark - Private Methods

- (void)initilize {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setNeedsLayout];
}

- (void)updateIndicators:(CALayer *)layer {
    
    CGPoint positionMultiplier = [self.dataSource positionMultiplierForEachPageForPageIndicatorView: self];
    CGSize pageContentSize = [self.dataSource contentSizeForEachPageForPageIndicatorView: self];
    CGPoint contentOffset = [self.dataSource contentOffsetForPageIndicatorView: self];
    
    [self.indicatorLayers enumerateObjectsUsingBlock:^(IndicatorLayer * indicatorLayer, NSUInteger idx, BOOL *stop) {
        
        CGPoint viewControllerLocation = CGPointMake( pageContentSize.width * (idx * positionMultiplier.x), pageContentSize.height * (idx * positionMultiplier.y));
        
        float distance = sqrt(pow( viewControllerLocation.x - contentOffset.x, 2) + pow( viewControllerLocation.y, 2));
        
        float indicatorOffset = INDICATOR_START_OFFSET + ((MAX_DIAMETER + INDICATOR_PADDING) / 2) + ((MAX_DIAMETER + INDICATOR_PADDING) * idx);
        
        if ( self.orientation == UCCPageIndicatorOrientationVertical ) {
            
            indicatorLayer.position = CGPointMake( CGRectGetMidX(layer.bounds), indicatorOffset);
            
        } else {
            
            indicatorLayer.position = CGPointMake(indicatorOffset, CGRectGetMidY(layer.bounds));
        }
        
        float scale = (distance / pageContentSize.height) * 100;
        
        indicatorLayer.scale = scale;
        
    }];
}

- (void)updateNumberOfIndicators {
    
    NSInteger numberOfPageIndicators = (self.dataSource) ? [self.dataSource numberOfPagesForPageIndicatorView:self] : 0;
    
    if ( self.indicatorLayers.count < numberOfPageIndicators ) {
        
        for (NSUInteger i = self.indicatorLayers.count; i < (NSUInteger)numberOfPageIndicators; i++) {
            
            IndicatorLayer * indicatorLayer = [[IndicatorLayer alloc] init];
            
            [self.indicatorLayers addObject: indicatorLayer];
            [self.layer addSublayer: indicatorLayer];
        }
        
    } else if ( self.indicatorLayers.count > numberOfPageIndicators ) {
        
        for (NSUInteger i = 0; i < self.indicatorLayers.count; i++) {
            
            IndicatorLayer * indicatorLayer = self.indicatorLayers[i];
            
            [self.indicatorLayers addObject: indicatorLayer];
            [self.layer addSublayer: indicatorLayer];
        }
        
    }
}

#pragma mark - Public Methods

- (void)reloadData {
    
    [self setNeedsLayout];
}

@end
