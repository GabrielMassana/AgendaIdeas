//
//  ABAImagePickerController.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 29/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABAImagePickerControllerDelegate <NSObject>

- (void)selectedImage:(UIImage *)image;

@end

@interface ABAImagePickerController : UIImagePickerController

@property (nonatomic, weak) id<ABAImagePickerControllerDelegate> pickerDelegate;

@end
