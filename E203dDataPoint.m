//
//  E203dDataPoint.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E203dDataPoint.h"

@implementation E203dDataPoint

+(E203dDataPoint*) dataPointFromDouble:(double *) values{
    E203dDataPoint* dataPoint = [[E203dDataPoint alloc] init];
    dataPoint.x = values[0];
    dataPoint.y = values[1];
    dataPoint.z = values[2];
    
    return dataPoint;

}


@end
