//
//  UIImage+Bundle.h
//  UICoreServices
//
//  Created by William Boles on 05/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)

+ (UIImage *)ucc_imageNamed:(NSString *)name
                  extension:(NSString *)extension
                     bundle:(NSBundle *)bundle;

+ (UIImage *)ucc_imageNamed:(NSString *)name
                  extension:(NSString *)extension
                 bundleName:(NSString *)bundleName;

@end
