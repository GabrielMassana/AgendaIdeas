//
//  Image.h
//  AgendaBastarda
//
//  Created by GabrielMassana on 27/11/2014.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABASerie;

@interface ABAImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * serieID;
@property (nonatomic, retain) ABASerie *serie;

@end
