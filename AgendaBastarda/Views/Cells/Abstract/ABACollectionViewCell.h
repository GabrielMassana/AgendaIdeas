//
//  ABACollectionViewCell.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABAAddSerieCell.h"

@interface ABACollectionViewCell : UICollectionViewCell

/**
 Retrieves the reuse Identifier for the Cell.
 */
+ (NSString *)reuseIdentifier;

/**
 Update the cell with Data.
 @param addSerieCell Serie Cell information.
 */
- (void)updateWithAddSerieCellData:(ABAAddSerieCell *)addSerieCell;

@property (nonatomic, strong) NSString *key;

@end
