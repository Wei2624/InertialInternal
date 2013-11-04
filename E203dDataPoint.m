//
//  E203dDataPoint.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E203dDataPoint.h"

@implementation E203dDataPoint

-(id) init
{
    self = [super init];
    if(self){
        self.timeStamp = -1; //default value if not set
    }
    return self;
}

+(E203dDataPoint*) dataPointFromDouble:(double *) values{
    E203dDataPoint* dataPoint = [[E203dDataPoint alloc] init];
    dataPoint.x = values[0];
    dataPoint.y = values[1];
    dataPoint.z = values[2];
    
    return dataPoint;

}

+(E203dDataPoint*) copyDataPoint:(E203dDataPoint *) sourcePoint{
    E203dDataPoint* dataPoint = [[E203dDataPoint alloc] init];
    dataPoint.x = sourcePoint.x;
    dataPoint.y = sourcePoint.y;
    dataPoint.z = sourcePoint.z;
    if (sourcePoint.timeStamp != -1){
        dataPoint.timeStamp=sourcePoint.timeStamp;
    }
    return dataPoint;
}


@end
