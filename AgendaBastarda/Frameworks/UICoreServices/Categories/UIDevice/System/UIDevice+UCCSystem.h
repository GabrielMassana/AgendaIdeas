//
//  UIDevice+UCCSystem.h
//  UICommon
//
//  Created by William Boles on 22/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (UCCSystem)

+ (BOOL) ucc_systemVersionIsLesserThanVersion:(float)version;
+ (BOOL) ucc_systemVersionIsGreaterThanVersion:(float)version;
+ (BOOL) ucc_systemVersionIsGreaterOrEqualToVersion:(float)version;
+ (BOOL) ucc_systemVersionIsLesserOrEqualToVersion:(float)version;

+ (BOOL) ucc_isDeviceRunningiOS7OrAbove DEPRECATED_MSG_ATTRIBUTE("Use [UIDevice ucc_systemVersionIsGreaterOrEqualToVersion(@\"7.0\")];");
+ (BOOL) ucc_isDeviceRunningiOS6OrAbove DEPRECATED_MSG_ATTRIBUTE("Use [UIDevice ucc_systemVersionIsGreaterOrEqualToVersion(@\"6.0\")];");
+ (BOOL) ucc_isDeviceRunningiOS5OrAbove DEPRECATED_MSG_ATTRIBUTE("Use [UIDevice ucc_systemVersionIsGreaterOrEqualToVersion(@\"5.0\")];");

@end
