//
//  ABAAddImageCollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAAddImageCollectionViewCell.h"

@interface ABAAddImageCollectionViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) ABAAddSerieCell *addSerieCell;

@end

@implementation ABAAddImageCollectionViewCell

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
    self.contentView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.imageButton];
    
}

#pragma mark - Subviews

- (UIButton *)imageButton
{
    if (!_imageButton)
    {
        _imageButton = [UIButton newAutoLayoutView];
        _imageButton.contentMode = UIViewContentModeScaleAspectFit;
        [_imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _imageButton;
}

- (UIImageView *)image
{
    if (!_image)
    {
        _image = [UIImageView newAutoLayoutView];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        _image.clipsToBounds = YES;
        _image.image = [UIImage imageNamed:@"image_placeholder"];
        _image.backgroundColor = [UIColor clearColor];
    }
    
    return _image;
}

- (UIView *)informationView
{
    if (!_informationView)
    {
        
    }
    
    return _informationView;
}

#pragma mark - Setters

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        
    }
    
    return _tapGestureRecognizer;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*---------------------*/

    [self.imageButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f,
                                                                              0.0f,
                                                                              0.0f,
                                                                              0.0f)];
    /*---------------------*/
    
    [self.image autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f,
                                                                        0.0f,
                                                                        0.0f,
                                                                        0.0f)];

}

#pragma mark - ButtonActions

- (void)imageButtonPressed:(UIButton *)sender
{
    [self.delegate userWantToChangeCellImage:sender];
}

#pragma mark - Constraints


- (void)updateWithAddSerieCellData:(ABAAddSerieCell *)addSerieCell
{
    self.addSerieCell = addSerieCell;
    self.key = addSerieCell.key;
}

@end
