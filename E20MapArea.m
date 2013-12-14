//
//  E20MapArea.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/5/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20MapArea.h"

@implementation E20MapArea

-(id) initWithCoordinatesX1: (double)x1 Y1: (double) y1 X2: (double)x2 Y2: (double) y2 X3: (double)x3 Y3: (double) y3 X4: (double)x4 Y4: (double) y4{
    self =[super init];
    
    if(self){
        self.areaLines = [[NSMutableArray alloc]init];
        self.areaPoints = [[NSMutableArray alloc] init];
        E202dMapPoint* p1 = [[E202dMapPoint alloc] initWithPositionX:x1*4 andPositionY:-y1*4];
        E202dMapPoint* p2 = [[E202dMapPoint alloc] initWithPositionX:x2*4 andPositionY:-y2*4];
        E202dMapPoint* p3 = [[E202dMapPoint alloc] initWithPositionX:x3*4 andPositionY:-y3*4];
        E202dMapPoint* p4 = [[E202dMapPoint alloc] initWithPositionX:x4*4 andPositionY:-y4*4];
        [self.areaPoints addObject:p1];
        [self.areaPoints addObject:p2];
        [self.areaPoints addObject:p3];
        self.centerPoint = [[E202dMapPoint alloc] initWithPositionX:(x4*4+x2*4)/2 andPositionY:(-y4*4+-y2*4)/2];
        [self.areaPoints addObject:p4];
        E20MapLine* l1 = [[E20MapLine alloc] initWithStartPosition:p1 andEndPosition:p2];
        E20MapLine* l2 = [[E20MapLine alloc] initWithStartPosition:p2 andEndPosition:p3];
        E20MapLine* l3 = [[E20MapLine alloc] initWithStartPosition:p3 andEndPosition:p4];
        E20MapLine* l4 = [[E20MapLine alloc] initWithStartPosition:p4 andEndPosition:p1];
        [self.areaLines addObject:l1];
        [self.areaLines addObject:l2];
        [self.areaLines addObject:l3];
        [self.areaLines addObject:l4];
    }
    return self;
    
}

@end
