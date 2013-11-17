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
@property    int phoneOrientation; //how is the phone oriented wrt gravity eg. z-up or y-up or...
                                    //0 +/-x up, 1 +/-y up, 2 +/-z up



+(E203dDataPoint*) dataPointFromDouble:(double *) values;
+(E203dDataPoint*) copyDataPoint:(E203dDataPoint *) sourcePoint;
-(void) normalizeDataPoint; //normalized dataPoint x,y,z values
-(double) dotProductWith:(E203dDataPoint*) secondPoint;
+(int) indexOfMaxAbsValueOfDataPoint:(E203dDataPoint *) dataPoint; //returns index (0,1,2) depending on whether x,y,or z is greatest in magnitude

-(double) getValueOf:(int) index;

@end
