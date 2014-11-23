//
//  UCCNavigationBar.m
//  Fling
//
//  Created by James Campbell on 01/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UCCNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface UCCNavigationBar ()

@property (nonatomic, strong) UIView * ucc_backgroundView;
@property (nonatomic, strong) UIImageView * backgroundImageView;

- (void)updateBackgroundStyle;

@end

@implementation UCCNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundStyle:UCCNavigationBarBackgroundStyleOpaqueColor animated:NO];
        self.layer.delegate = self;
        self.clipsToBounds = NO;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [self updateBackgroundStyle];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.colorView.frame = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
    
    [self updateBackgroundStyle];
}

- (UIView *)colorView {
    
    if ( !_ucc_backgroundView  ) {
        
        _ucc_backgroundView = [[UIView alloc] init];
        
        [self insertSubview:_ucc_backgroundView atIndex:0];
    }
    
    return _ucc_backgroundView;
}

- (UIImageView *)backgroundImageView {
    
    if ( !_backgroundImageView ) {
        
        self.backgroundImageView = [[UIImageView alloc] init];
        
        [self.ucc_backgroundView addSubview: self.backgroundImageView];
    }
    
    return _backgroundImageView;
}

- (void)setBackgroundStyle:(UCCNavigationBarBackgroundStyle)backgroundStyle {
    
    [self setBackgroundStyle:backgroundStyle animated: NO];
}

- (void)setBackgroundStyle:(UCCNavigationBarBackgroundStyle)backgroundStyle animated:(BOOL)animated {
    
    _backgroundStyle = backgroundStyle;
    
    [UIView animateWithDuration:0.5 * animated delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self updateBackgroundStyle];
        
    } completion:nil];
    
}

- (void)updateBackgroundStyle {
    
    self.ucc_backgroundView.alpha = 1.0 * (self.backgroundStyle == UCCNavigationBarBackgroundStyleOpaqueColor);
    self.ucc_backgroundView.backgroundColor = self.barTintColor;
    
    self.backgroundImageView.image = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
}

@end
