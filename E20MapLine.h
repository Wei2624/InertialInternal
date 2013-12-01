//
//  E20MapLine.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E20Matrix.h"
#import "E202dMapPoint.h"

@interface E20MapLine : NSObject

@property E202dMapPoint* startPosition;
@property E202dMapPoint* endPosition;
@property bool crossable; //tells us whether line is something users can cross over

-(id) initWithStartPosition: (E202dMapPoint*)pos1 andEndPosition: (E202dMapPoint*)pos2; //initializes line
-(id) initWithCartesianX1: (double) x1 Y1:(double) y1 X2:(double) x2 Y2:(double) y2 boolCrossable: (bool) crossable;
-(E20Matrix*) getLineVector;
@end
