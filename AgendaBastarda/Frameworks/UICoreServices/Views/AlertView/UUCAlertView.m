//
//  UUCAlertView.m
//  UICoreServices
//
//  Created by James Campbell on 08/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UUCAlertView.h"

@interface UUCAlertView () <UIAlertViewDelegate>

@end

@implementation UUCAlertView

+(instancetype) alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    return [[self alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

+(instancetype) alertViewWithError:(NSError* )error cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    return [[self alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

-(instancetype) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])
    {
        self.delegate = self;
    }
    
    return self;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( self.onButtonPressed && [alertView cancelButtonIndex] != buttonIndex ) {
        
        self.onButtonPressed (self, buttonIndex);
        
    } else if ( self.onCancelPressed ) {
        
        self.onCancelPressed(self);
    }
}

@end
