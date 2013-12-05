//
//  E20MapArea.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/5/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E20Matrix.h"
#import "E202dMapPoint.h"
#import "E20MapLine.h"

@interface E20MapArea : NSObject

@property NSMutableArray* areaPoints;
@property NSMutableArray* areaLines;



-(id) initWithCoordinatesX1: (double)x1 Y1: (double) y1 X2: (double)x2 Y2: (double) y2 X3: (double)x3 Y3: (double) y3 X4: (double)x4 Y4: (double) y4;



@end
