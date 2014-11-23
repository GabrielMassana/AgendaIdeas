//
//  UUCAlertView.h
//  UICoreServices
//
//  Created by James Campbell on 08/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUCAlertView;

typedef void (^UUCAlertViewButtonPressed)(UUCAlertView *alertView, NSInteger buttonIndex);
typedef void (^UUCAlertViewCancelPressed)(UUCAlertView *alertView);

@interface UUCAlertView : UIAlertView

@property (nonatomic, copy) UUCAlertViewButtonPressed onButtonPressed;
@property (nonatomic, copy) UUCAlertViewCancelPressed onCancelPressed;
@property (nonatomic, strong) NSDictionary *userInfo;

+(instancetype) alertViewWithTitle:(NSString* )title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
+(instancetype) alertViewWithError:(NSError* )error cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
