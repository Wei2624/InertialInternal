//
//  E203dDataPoint.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface E203dDataPoint : NSObject
@property    double x;
@property    double y;
@property    double z;
@property    NSTimeInterval timeStamp;

+(E203dDataPoint*) dataPointFromDouble:(double *) values;


@end
