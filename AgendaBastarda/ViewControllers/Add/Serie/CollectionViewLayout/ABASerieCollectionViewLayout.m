//
//  ABASerieCollectionViewLayout.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 24/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABASerieCollectionViewLayout.h"

@interface ABASerieCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation ABASerieCollectionViewLayout

#pragma mark - Init

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    return self;
}

#pragma mark - UICollectionViewLayout

-(void)prepareLayout
{
    [self setItemAttributes:nil];
    self.itemAttributes = [[NSMutableArray alloc] init];
    
    NSUInteger numberOfItems = 7;
    
    CGFloat totalHeight = 0.0f;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    for (NSUInteger index = 0; index < numberOfItems; index++)
    {
        CGSize itemSize;
        
        CGFloat xOffset = 0;
        CGFloat yOffset = 0;
        
        if (index == 0)
        {
            CGFloat height = (screenSize.width / 3) * 2;
            itemSize = CGSizeMake(screenSize.width,
                                  height);
            xOffset = 0;
            yOffset = 0;

            totalHeight += height;
        }
        else if (index== 1)
        {
            CGFloat height = 60;

            itemSize = CGSizeMake(screenSize.width,
                                  height);
            xOffset = 0;
            yOffset = totalHeight;
            
            totalHeight += height;
            
        }
        else if (index == 2 ||
                 index == 3)
        {
            CGFloat height = 35;
            
            itemSize = CGSizeMake(screenSize.width,
                                  height);
            xOffset = 0;
            yOffset = totalHeight;
            
            totalHeight += height;
            
        }
        else if (index >= 4)
        {
            
            CGFloat height = 35;
            
            itemSize = CGSizeMake(screenSize.width,
                                  height);
            xOffset = 0;
            yOffset = totalHeight;
            
            totalHeight += height;
        }
        

        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index
                                                     inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attributes.frame = CGRectIntegral(CGRectMake(xOffset,
                                                     yOffset,
                                                     itemSize.width,
                                                     itemSize.height));
        
        [self.itemAttributes addObject:attributes];
    }
    
    // Return this in collectionViewContentSize
    self.contentSize = CGSizeMake(screenSize.width,
                                  totalHeight);
}

-(CGSize)collectionViewContentSize
{
    return self.contentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.itemAttributes objectAtIndex:indexPath.row];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings)
    {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        
    }]];
}


@end
