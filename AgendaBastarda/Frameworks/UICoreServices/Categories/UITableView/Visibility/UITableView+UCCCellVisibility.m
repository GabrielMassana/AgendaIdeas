//
//  UITableView+USNCellVisibility.m
//  UICommon
//
//  Created by William Boles on 01/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UITableView+UCCCellVisibility.h"

@implementation UITableView (UCCCellVisibility)

#pragma mark - Visibility

- (BOOL) ucc_isCellVisible:(UITableViewCell *)cell
{
    CGRect cellRect = [self rectForRowAtIndexPath:[self indexPathForCell:cell]];
    
    CGPoint cellCenterPoint = CGPointMake(cellRect.origin.x+((cellRect.size.width)/2),
                                          cellRect.origin.y+((cellRect.size.height)/2));
    
    return CGRectContainsPoint(self.bounds, cellCenterPoint);
}

@end
