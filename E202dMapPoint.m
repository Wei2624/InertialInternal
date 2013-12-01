//
//  E202dMapPoint.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E202dMapPoint.h"

@implementation E202dMapPoint

-(id) init
{
    //creates point (0,0) origin
    self = [super init];
    if(self){
        self.position = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    }
    return self;
}
-(id) initWithPositionX: (double)x andPositionY: (double)y{
    self =[super init];
    double pos[2] = {x,y};
    if(self){
        self.position = [[E20Matrix alloc] initMatrixVectorWithRows:2 andVectorData:pos];
    }
    return self;
}

-(id) initWith2x1MatrixVector: (E20Matrix*) matrix{
    self =[super init];

    if(self){
        self.position = matrix.returnSelfCopy;
    }
    return self;

}

+(E202dMapPoint*) copyMapPoint:(E202dMapPoint*) dataPoint{
    E202dMapPoint* newPoint = [[E202dMapPoint alloc] initWithPositionX:dataPoint.position.data[0][0] andPositionY:dataPoint.position.data[1][0]];
    return newPoint;
}

@end
