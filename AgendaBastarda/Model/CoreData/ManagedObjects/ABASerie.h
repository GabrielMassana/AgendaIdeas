//
//  Serie.h
//  AgendaBastarda
//
//  Created by Jose Antonio Gabriel Massana on 27/11/14.
//  Copyright (c) 2014 GabrielMassana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABAImage;

@interface ABASerie : NSManagedObject

@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * serieID;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSNumber * weekly;
@property (nonatomic, retain) NSNumber * aproxDate;
@property (nonatomic, retain) NSNumber * daily;
@property (nonatomic, retain) ABAImage *image;

@end
