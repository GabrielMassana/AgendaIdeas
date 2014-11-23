//
//  UIImage+OrientationFix.h
//  Fling
//
//  Created by Marko Strizic on 08/04/14.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OrientationFix)

-(UIImage*) imageWithFixedOrentationAndResolutionInPixels:(CGFloat)resolution;
-(UIImage*) imageWithFixedOrentation;


@end
