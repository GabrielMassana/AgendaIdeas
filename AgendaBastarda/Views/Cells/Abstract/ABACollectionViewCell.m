//
//  ABACollectionViewCell.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 15/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABACollectionViewCell.h"

@implementation ABACollectionViewCell

#pragma mark - Identifier

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
