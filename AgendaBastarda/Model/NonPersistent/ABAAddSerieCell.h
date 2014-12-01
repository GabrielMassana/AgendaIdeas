//
//  ABAAddSerieCell.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 27/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ABAAddSerieCellType)
{
    ABAAddSerieCellTypeImage        = 0,
    ABAAddSerieCellTypeTextField    = 1,
    ABAAddSerieCellTypeTextFieldDate = 2,
    ABAAddSerieCellTypeSwitch       = 3,
};

@interface ABAAddSerieCell : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) ABAAddSerieCellType type;
@property (nonatomic, assign) BOOL canBeginEditedWithNext;
@property (nonatomic, assign) BOOL doneShouldReturnTextFieldAction;
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign) UITextAutocorrectionType autocorrectType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) BOOL switchOn;

@end
