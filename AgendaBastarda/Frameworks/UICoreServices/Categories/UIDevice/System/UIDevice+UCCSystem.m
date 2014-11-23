//
//  UIDevice+UCCSystem.m
//  UICommon
//
//  Created by William Boles on 22/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UIDevice+UCCSystem.h"

@implementation UIDevice (UCCSystem)

#pragma mark - Version

+ (BOOL) ucc_systemVersionIsLesserThanVersion:(float)version {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] < version;
}

+ (BOOL) ucc_systemVersionIsGreaterThanVersion:(float)version {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] > version;
}

+ (BOOL) ucc_systemVersionIsGreaterOrEqualToVersion:(float)version {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= version;
}

+ (BOOL) ucc_systemVersionIsLesserOrEqualToVersion:(float)version {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] <= version;
}

#pragma mark - Deprecated

+ (BOOL) ucc_isDeviceRunningiOS7OrAbove
{
    return [self ucc_systemVersionIsGreaterOrEqualToVersion: 7.0];
}

+ (BOOL) ucc_isDeviceRunningiOS6OrAbove
{
    return [self ucc_systemVersionIsGreaterOrEqualToVersion: 6.0];
}

+ (BOOL) ucc_isDeviceRunningiOS5OrAbove
{
    return [self ucc_systemVersionIsGreaterOrEqualToVersion: 5.0];
}

@end
