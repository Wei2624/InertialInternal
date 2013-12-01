//
//  E202dMapPoint.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E20Matrix.h"
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"

@interface E202dMapPoint : NSObject

@property E20Matrix* position;

-(id) initWithPositionX: (double)x andPositionY: (double)y; //initializes position value
-(id) initWith2x1MatrixVector: (E20Matrix*) matrix; //initializes position value
+(E202dMapPoint*) copyMapPoint:(E202dMapPoint*) dataPoint;
@end
