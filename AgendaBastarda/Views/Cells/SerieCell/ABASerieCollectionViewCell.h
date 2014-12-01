//
//  ABASerieCollectionViewCell.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABACollectionViewCell.h"
#import "ABASerie.h"

@class ABASerieCollectionViewCell;

@protocol ABASerieCollectionViewCellDelegate <NSObject>

- (void)longPressGestureRecognizerShouldBegin:(UIGestureRecognizer *)sender cell: (ABASerieCollectionViewCell *) cell;
- (void)longPressGestureRecognizerChanged:(UIGestureRecognizer *)sender cell: (ABASerieCollectionViewCell *) cell;
- (void)longPressGestureRecognizerEnded;

@end

@interface ABASerieCollectionViewCell : ABACollectionViewCell

/**
 Update the cell with Data.
 @param serie Serie Data information.
 */
- (void)updateWithPersistentSerieCellData:(ABASerie *)serie;

@property (nonatomic, weak) id<ABASerieCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) ABASerie *serie;

@end
