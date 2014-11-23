//
//  ABASerieCollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABASerieCollectionViewCell.h"
#import "ABAColor.h"
#import "ABAFont.h"

static CGFloat const kImageSizeWidth = 85.0f;
//static CGFloat const kNameSizeHeight = 50.0f;
static CGFloat const kFromToSizeHeight = 25.0f;
static CGFloat const kFromToSizeWidth = 50.0f;
static CGFloat const kInformationSizeWidth = 10.0f;

@interface ABASerieCollectionViewCell()

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *startsTitleLabel;
@property (nonatomic, strong) UILabel *startsLabel;

@property (nonatomic, strong) UILabel *endsTitleLabel;
@property (nonatomic, strong) UILabel *endsLabel;

@property (nonatomic, strong) UILabel *informationToSeeLabel;
@property (nonatomic, strong) UILabel *informationToShareLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ABASerieCollectionViewCell

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
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.startsTitleLabel];
    [self.contentView addSubview:self.startsLabel];
    [self.contentView addSubview:self.endsTitleLabel];
    [self.contentView addSubview:self.endsLabel];
    [self.contentView addSubview:self.informationToSeeLabel];
    [self.contentView addSubview:self.informationToShareLabel];
    [self.contentView addSubview:self.bottomLine];
}

#pragma mark - Subviews

- (UIImageView *)image
{
    if (!_image)
    {
        _image = [UIImageView newAutoLayoutView];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        _image.image = [UIImage imageNamed:@"placeholder"];
        _image.backgroundColor = [UIColor redColor];
    }
    
    return _image;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel newAutoLayoutView];
//        _nameLabel.textColor = [FSNColor flingCoachTextGrey];
        _nameLabel.font = [ABAFont openSansBoldFontWithSize:22.0f];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.text = @"TEXT NAME SERIE  SERIE SERIE ";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.minimumScaleFactor = 0.25f;
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _nameLabel;
}

- (UILabel *)startsTitleLabel
{
    if (!_startsTitleLabel)
    {
        _startsTitleLabel = [UILabel newAutoLayoutView];
//        _startsTitleLabel.textColor = [FSNColor flingCoachTextGrey];
        _startsTitleLabel.font = [ABAFont openSansSemiboldFontWithSize:14.0f];
        _startsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _startsTitleLabel.backgroundColor = [UIColor clearColor];
        _startsTitleLabel.text = NSLocalizedString(@"Starts_Label", nil);
    }
    
    return _startsTitleLabel;
}

- (UILabel *)startsLabel
{
    if (!_startsLabel)
    {
        _startsLabel = [UILabel newAutoLayoutView];
//        _startsLabel.textColor = [FSNColor flingCoachTextGrey];
        _startsLabel.font = [ABAFont openSansRegularFontWithSize:14.0f];
        _startsLabel.textAlignment = NSTextAlignmentRight;
        _startsLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _startsLabel;
}

- (UILabel *)endsTitleLabel
{
    if (!_endsTitleLabel)
    {
        _endsTitleLabel = [UILabel newAutoLayoutView];
//        _endsTitleLabel.textColor = [FSNColor flingCoachTextGrey];
        _endsTitleLabel.font = [ABAFont openSansSemiboldFontWithSize:14.0f];
        _endsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _endsTitleLabel.backgroundColor = [UIColor clearColor];
        _endsTitleLabel.text = NSLocalizedString(@"Ends_Label", nil);
    }
    
    return _endsTitleLabel;
}

- (UILabel *)endsLabel
{
    if (!_endsLabel)
    {
        _endsLabel = [UILabel newAutoLayoutView];
//        _endsLabel.textColor = [FSNColor flingCoachTextGrey];
        _endsLabel.font = [ABAFont openSansRegularFontWithSize:14.0f];
        _endsLabel.textAlignment = NSTextAlignmentRight;
        _endsLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _endsLabel;
}

- (UILabel *)informationToSeeLabel
{
    if (!_informationToSeeLabel)
    {
        _informationToSeeLabel = [UILabel newAutoLayoutView];
//        _informationToSeeLabel.textColor = [FSNColor flingCoachTextGrey];
        _informationToSeeLabel.font = [ABAFont openSansLightFontWithSize:11.0f];
        _informationToSeeLabel.textAlignment = NSTextAlignmentLeft;
        _informationToSeeLabel.backgroundColor = [UIColor clearColor];
        _informationToSeeLabel.text = NSLocalizedString(@"View_Details", nil);
    }
    
    return _informationToSeeLabel;
}

- (UILabel *)informationToShareLabel
{
    if (!_informationToShareLabel)
    {
        _informationToShareLabel = [UILabel newAutoLayoutView];
//        _informationToShareLabel.textColor = [FSNColor flingCoachTextGrey];
        _informationToShareLabel.font = [ABAFont openSansLightFontWithSize:11.0f];
        _informationToShareLabel.textAlignment = NSTextAlignmentRight;
        _informationToShareLabel.backgroundColor = [UIColor clearColor];
        _informationToShareLabel.text = NSLocalizedString(@"Tap_to_Share", nil);
    }
    
    return _informationToShareLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [UIView newAutoLayoutView];
        _bottomLine.backgroundColor = [UIColor grayColor];
    }
    
    return _bottomLine;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*-------------------*/
    
    [self.image autoSetDimension:ALDimensionWidth
                          toSize:kImageSizeWidth];
    
    [self.image autoPinEdgeToSuperviewEdge:ALEdgeTop
                                 withInset:10.0f];
    
    [self.image autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                 withInset:10.0f];
    
    [self.image autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                 withInset:10.0f];
    
    /*-------------------*/
    
//    [self.nameLabel autoSetDimension:ALDimensionHeight
//                              toSize:kNameSizeHeight];
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                     withInset:10.0f];
    
    [self.nameLabel autoPinEdge:ALEdgeLeft
                         toEdge:ALEdgeRight
                         ofView:self.image
                     withOffset:10.0f];
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                     withInset:10.0f];
    
    /*-------------------*/
    
    [self.startsTitleLabel autoSetDimension:ALDimensionHeight
                                     toSize:kFromToSizeHeight];
    
    [self.startsTitleLabel autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.nameLabel
                            withOffset:1.0f];
    
    [self.startsTitleLabel autoSetDimension:ALDimensionWidth
                                     toSize:kFromToSizeWidth];
    
    [self.startsTitleLabel autoPinEdge:ALEdgeLeft
                                toEdge:ALEdgeRight
                                ofView:self.image
                            withOffset:10.0f];
    
    /*-------------------*/
    
    [self.startsLabel autoSetDimension:ALDimensionHeight
                                     toSize:kFromToSizeHeight];
    
    [self.startsLabel autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.nameLabel
                            withOffset:1.0f];
    
    [self.startsLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeRight
                           ofView:self.startsTitleLabel
                       withOffset:1.0f];
    
    [self.startsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                     withInset:10.0f];
    
    /*-------------------*/
    
    [self.endsTitleLabel autoSetDimension:ALDimensionHeight
                                   toSize:kFromToSizeHeight];
    
    [self.endsTitleLabel autoPinEdge:ALEdgeTop
                              toEdge:ALEdgeBottom
                              ofView:self.startsTitleLabel
                          withOffset:1.0f];
    
    [self.endsTitleLabel autoSetDimension:ALDimensionWidth
                                   toSize:kFromToSizeWidth];
    
    [self.endsTitleLabel autoPinEdge:ALEdgeLeft
                              toEdge:ALEdgeRight
                              ofView:self.image
                          withOffset:10.0f];
    /*-------------------*/
    
    [self.endsLabel autoSetDimension:ALDimensionHeight
                                toSize:kFromToSizeHeight];
    
    [self.endsLabel autoPinEdge:ALEdgeTop
                           toEdge:ALEdgeBottom
                           ofView:self.startsLabel
                       withOffset:1.0f];
    
    [self.endsLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeRight
                           ofView:self.endsTitleLabel
                       withOffset:1.0f];
    
    [self.endsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:10.0f];
    
    /*-------------------*/
    
    [self.informationToSeeLabel autoSetDimension:ALDimensionHeight
                                            toSize:kInformationSizeWidth];
    
    [self.informationToSeeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                                   withInset:10.0f];
    
    [self.informationToSeeLabel autoPinEdge:ALEdgeLeft
                                       toEdge:ALEdgeRight
                                       ofView:self.image
                                   withOffset:10.0f];
    
    [self.informationToSeeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                   withInset:10.0f];
    /*-------------------*/
    
    [self.informationToShareLabel autoSetDimension:ALDimensionHeight
                                          toSize:kInformationSizeWidth];
    
    [self.informationToShareLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                                   withInset:10.0f];
    
    [self.informationToShareLabel autoPinEdge:ALEdgeLeft
                                     toEdge:ALEdgeRight
                                     ofView:self.image
                                 withOffset:10.0f];
    
    [self.informationToShareLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                 withInset:10.0f];

    /*-------------------*/
    
    [self.bottomLine autoSetDimension:ALDimensionHeight
                               toSize:1.0f];
    
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                      withInset:0.0f];
    
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight
                                      withInset:0.0f];
    
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                      withInset:0.0f];
    
}

@end
