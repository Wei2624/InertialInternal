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
        self.phoneOrientation = -1; //default value if not set
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

-(void) normalizeDataPoint{
    E203dDataPoint* dataPoint = self;
    double sum = pow(dataPoint.x,2)+pow(dataPoint.y,2)+pow(dataPoint.z,2);
    sum = pow(sum,0.5);
    dataPoint.x = dataPoint.x/sum;
    dataPoint.y = dataPoint.y/sum;
    dataPoint.z = dataPoint.z/sum;
}

-(double) dotProductWith:(E203dDataPoint*) secondPoint{
    E203dDataPoint* firstPoint = self;
    double sum = firstPoint.x*secondPoint.x+firstPoint.y*secondPoint.y+firstPoint.z*secondPoint.z;
    return sum;
}

+(int) indexOfMaxAbsValueOfDataPoint:(E203dDataPoint *) dataPoint{
    if(ABS(dataPoint.x)>=ABS(dataPoint.y) && ABS(dataPoint.x)>=ABS(dataPoint.z)){
        return 0;
    }
    else if(ABS(dataPoint.y)>=ABS(dataPoint.x) && ABS(dataPoint.y)>=ABS(dataPoint.z)){
        return 1;
    }
    else{
        return 2;
    }
}

@end
