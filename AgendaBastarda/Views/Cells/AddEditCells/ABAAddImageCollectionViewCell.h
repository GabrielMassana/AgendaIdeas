//
//  ABAAddImageCollectionViewCell.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABACollectionViewCell.h"

@protocol ABAAddImageCollectionViewCellDelegate <NSObject>

- (void)userWantToChangeCellImage:(UIButton *)button;

@end

@interface ABAAddImageCollectionViewCell : ABACollectionViewCell

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, weak) id<ABAAddImageCollectionViewCellDelegate> delegate;

@end



