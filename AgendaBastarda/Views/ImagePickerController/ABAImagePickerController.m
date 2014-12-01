//
//  ABAImagePickerController.m
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 29/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import "ABAImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ABAImagePickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ABAImagePickerController

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.allowsEditing = NO;
        self.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // If the image cames from Camera Roll
    if (image == nil)
    {
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *ref = url.absoluteString;
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[NSURL URLWithString:ref]
                 resultBlock:^(ALAsset *asset)
         {
             image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
             [self.pickerDelegate selectedImage:image];
             
             [self dismissViewController];
         }
                failureBlock:^(NSError *error)
         {
             [self dismissViewController];
         }];

    }
    else
    {
        [self.pickerDelegate selectedImage:image];

        [self dismissViewController];
    }
}

#pragma mark - DismissViewController

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^
     {
     }];
}

@end
