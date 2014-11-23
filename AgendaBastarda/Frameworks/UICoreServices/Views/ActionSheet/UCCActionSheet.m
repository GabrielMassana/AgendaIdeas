//
//  UCCActionSheet.m
//  UICoreServices
//
//  Created by James Campbell on 17/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UCCActionSheet.h"

@interface UCCActionSheet () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation UCCActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)title
{
    
    UCCActionSheet *actionSheet = [[self alloc] init];
    actionSheet.delegate = actionSheet;
    actionSheet.title = title;
    
    return actionSheet;
}

- (NSMutableArray *)blocks {
    
    if ( !_blocks )
    {
        _blocks = [[NSMutableArray alloc] init];
    }
    
    return _blocks;
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    id block = self.blocks[buttonIndex];
    
    if ( block != [NSNull null] )
    {
        ((UCCActionSheetButtonPressed2)block)(self);
    }
}

- (NSInteger)addButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block
{
    if ( block)
    {
        [self.blocks addObject: block];
    }
    else
    {
        [self.blocks addObject:[NSNull null]];
    }
    
    return [self addButtonWithTitle: title];
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block
{
    NSInteger index = [self addButtonWithTitle:title andBlock:block];
    [self setCancelButtonIndex: index];
    return index;
}

- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block
{
    NSInteger index = [self addButtonWithTitle:title andBlock:block];
    [self setDestructiveButtonIndex: index];
    return index;
}

@end
