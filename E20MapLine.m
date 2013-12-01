//
//  E20MapLine.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20MapLine.h"

@implementation E20MapLine
-(id) init
{
    //creates line (0,0)->(0,0)
    self = [super init];
    if(self){
        self.startPosition = [[E202dMapPoint alloc] init];
        self.endPosition = [[E202dMapPoint alloc] init];
        self.crossable = NO;
    }
    return self;
}
-(id) initWithStartPosition: (E202dMapPoint*)pos1 andEndPosition: (E202dMapPoint*)pos2{
    self =[super init];
    if(self){
        self.startPosition = [E202dMapPoint copyMapPoint:pos1];
        self.endPosition = [E202dMapPoint copyMapPoint:pos2];
        self.crossable = NO;
    }
    return self;
}
-(id) initWithCartesianX1: (double) x1 Y1:(double) y1 X2:(double) x2 Y2:(double) y2 boolCrossable: (bool) crossable{
    self =[super init];
    if(self){
        E202dMapPoint* startPos = [[E202dMapPoint alloc] initWithPositionX:x1 andPositionY:y1];
        E202dMapPoint* endPos = [[E202dMapPoint alloc] initWithPositionX:x2 andPositionY:y2];
        self.startPosition = startPos;
        self.endPosition = endPos;
        self.crossable = crossable;
    }
    return self;
}

-(E20Matrix*) getLineVector{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    double** newMatrixData = newMatrix.data;
    double** startData = self.startPosition.position.data;
    double** endData = self.endPosition.position.data;
    newMatrixData[0][0] = endData[0][0]-startData[0][0];
    newMatrixData[1][0] = endData[1][0]-startData[1][0];
    
    return newMatrix;

}

@end
