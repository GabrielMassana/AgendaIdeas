//
//  ABAAddSettingsCollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddSettingsCollectionViewCell.h"
#import "ABAFont.h"
#import "ABAColor.h"

@interface ABAAddSettingsCollectionViewCell ()

@property (nonatomic, strong) ABAAddSerieCell *addSerieCell;

@end

@implementation ABAAddSettingsCollectionViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setupView
{
    self.contentView.backgroundColor = [ABAColor lightLightGrayColor];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.switcher];
}

#pragma mark - Subviews

- (UILabel *)title
{
    if (!_title)
    {
        _title = [UILabel newAutoLayoutView];
        _title.font = [ABAFont openSansRegularFontWithSize:15.0f];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.text = @"Setting:";
    }
    
    return _title;
}

- (UISwitch *)switcher
{
    if (!_switcher)
    {
        _switcher = [UISwitch newAutoLayoutView];
        _switcher.tintColor = [UIColor lightGrayColor];
        _switcher.onTintColor = [UIColor lightGrayColor];
    }
    
    return _switcher;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*---------------------*/

    [self.title autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f,
                                                                        10.0f,
                                                                        0.0f,
                                                                        0.0f)];
    /*---------------------*/

    [self.switcher autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.switcher autoPinEdgeToSuperviewEdge:ALEdgeRight
                                    withInset:10.0f];
}

- (void)updateWithAddSerieCellData:(ABAAddSerieCell *)addSerieCell
{
    self.addSerieCell = addSerieCell;
    self.key = addSerieCell.key;
    
    self.title.text = addSerieCell.title;
    self.switcher.on = addSerieCell.switchOn;
}

@end

