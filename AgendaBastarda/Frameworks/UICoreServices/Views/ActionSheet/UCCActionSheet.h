//
//  UCCActionSheet.h
//  UICoreServices
//
//  Created by James Campbell on 17/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCCActionSheet;

typedef void (^UCCActionSheetButtonPressed2)(UCCActionSheet *actionSheet);
typedef void (^UCCActionSheetButtonPressed)(UCCActionSheet *actionSheet, NSInteger buttonIndex);
typedef void (^UCCActionSheetDestructivePressed)(UCCActionSheet *actionSheet);
typedef void (^UCCActionSheetCancelPressed)(UCCActionSheet *actionSheet);

@interface UCCActionSheet : UIActionSheet

@property (nonatomic, copy) UCCActionSheetButtonPressed onButtonPressed;
@property (nonatomic, copy) UCCActionSheetDestructivePressed onDestructivePressed;
@property (nonatomic, copy) UCCActionSheetCancelPressed onCancelPressed;

+ (instancetype)actionSheetWithTitle:(NSString *)title;

- (NSInteger)addButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block;
- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title andBlock:(UCCActionSheetButtonPressed2)block;

@end
