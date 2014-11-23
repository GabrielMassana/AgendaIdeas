//
//  UIImage+Bundle.m
//  UICoreServices
//
//  Created by William Boles on 05/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

#pragma mark - UIImage

+ (UIImage *)ucc_imageNamed:(NSString *)name
                  extension:(NSString *)extension
                     bundle:(NSBundle *)bundle
{
    NSURL *imageURL = [bundle URLForResource:name withExtension:extension];
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
}

+ (UIImage *)ucc_imageNamed:(NSString *)name
                  extension:(NSString *)extension
                 bundleName:(NSString *)bundleName
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"]];
    
    return [UIImage ucc_imageNamed:name
                         extension:extension
                            bundle:bundle];
}

@end
