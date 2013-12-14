//
//  E20MapInfo.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20MapInfo.h"

@implementation E20MapInfo

+(bool) isPoint: (E202dMapPoint*) position InsideMapArea: (E20MapArea*) mapArea{
    double x = position.position.data[0][0];
    double y = position.position.data[1][0];
    E202dMapPoint* p1 = [mapArea.areaPoints objectAtIndex:3];
    double xmin = p1.position.data[0][0];
    double ymin = p1.position.data[1][0];
    p1 = [mapArea.areaPoints objectAtIndex:1];
    double xmax = p1.position.data[0][0];
    double ymax = p1.position.data[1][0];
    if(x>=xmin && x<=xmax && y>=ymin && y<=ymax){
        return YES;
    }
    
    return NO;
}

+(bool) doTheyIntersectLine1: (E20MapLine*) line1 andLine2: (E20MapLine*) line2 {
    E20Matrix* A = [[E20Matrix alloc] initWithRows:2 andColumns:2];
    E20Matrix* B = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    double** adata = A.data;
    double** bdata = B.data;
    double** vec1 = line1.getLineVector.data;
    double** vec2 = line2.getLineVector.data;
    adata[0][0] = vec1[0][0];
    adata[0][1] = -vec2[0][0];
    adata[1][0] = vec1[1][0];
    adata[1][1] = -vec2[1][0];
    NSLog(@"%f , %f , %f , %f",adata[0][0],adata[0][1],adata[1][0],adata[1][1]);
    if([A get2x2Det]!=0){
        bdata[0][0] = line2.startPosition.position.data[0][0]-line1.startPosition.position.data[0][0];
        bdata[1][0] = line2.startPosition.position.data[1][0]-line1.startPosition.position.data[1][0];
        NSLog(@"%f , %f ",bdata[0][0],bdata[1][0]);
        E20Matrix*Ainv = [A get2x2Inverse];
        NSLog(@"%f , %f , %f , %f",Ainv.data[0][0],Ainv.data[0][1],Ainv.data[1][0],Ainv.data[1][1]);
        E20Matrix*X = [Ainv multiply2x2MatrixWith2x1:B];
        NSLog(@"%f , %f ",X.data[0][0],X.data[1][0]);
        if(X.data[0][0]<=1 && X.data[0][0]>=0 && X.data[1][0]<=1 && X.data[1][0]>=0 ){
            return YES;
        }
    }
    return NO;
    
}
+(E20MapLine*) closestLineOnMap: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position{

    double x = position.position.data[0][0];
    double y = position.position.data[1][0];
    
    E202dMapPoint* p1 = [mapArea.areaPoints objectAtIndex:3];
    double xmin = p1.position.data[0][0];
    double ymin = p1.position.data[1][0];
    p1 = [mapArea.areaPoints objectAtIndex:1];
    double xmax = p1.position.data[0][0];
    double ymax = p1.position.data[1][0];
    if(x<=xmin){
        return [mapArea.areaLines objectAtIndex:0];
    }
    else if (x>=xmax){
        return [mapArea.areaLines objectAtIndex:2];
    }
    else if (y>=ymax){
        return [mapArea.areaLines objectAtIndex:1];
    }
    else{
        return [mapArea.areaLines objectAtIndex:3];
    }
}

+(double) closestDistanceToMap: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position{
    double dist=+INFINITY;

    E20MapLine* tempLine = [E20MapInfo closestLineOnMap:mapArea toPointOutsideMap:position];
    dist =[E20MapInfo closestDistanceFromPoint:position ToLine:tempLine];
    
    return dist;
}

+(E202dMapPoint*) closestPointOnMap: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position{

    E202dMapPoint* closestPoint;

    E20MapLine* tempLine = [E20MapInfo closestLineOnMap:mapArea toPointOutsideMap:position];
    closestPoint = [E20MapInfo closestPointOnLine:tempLine toPoint:position];
    
    return closestPoint;

}

+(double) closestDistanceFromPoint: (E202dMapPoint*) position ToLine: (E20MapLine*) line{
    E202dMapPoint* closestPoint = [E20MapInfo closestPointOnLine:line toPoint:position];
    E20Matrix* vec1 = [closestPoint.position subtract2x1MatrixWith2x1:position.position];
    
    return vec1.get2x1VectorMagnitude;
}

+(E202dMapPoint*) closestPointOnLine: (E20MapLine*) line toPoint:(E202dMapPoint*) position  {
    E20Matrix* vec1 = line.getLineVector;
    E20MapLine* line2 = [[E20MapLine alloc] initWithStartPosition:line.startPosition andEndPosition:position];
    E20Matrix* vec2 = line2.getLineVector;
    NSLog(@"%f , %f , %f , %f",vec1.data[0][0],vec1.data[1][0],vec2.data[0][0],vec2.data[1][0]);
    double dot = [vec1 get2x1VectorDotProductWith:vec2]/vec1.get2x1VectorMagnitude/vec1.get2x1VectorMagnitude;
    if(dot<=0){
        return line.startPosition;
    }
    else if (dot>=1){
        return line.endPosition;
    }
    else{
        E20Matrix* closestPointVector = [line.startPosition.position add2x1MatrixWith2x1:[vec1 multiply2x1MatrixWithScalar:dot]];
        E202dMapPoint* closestPoint = [[E202dMapPoint alloc]initWith2x1MatrixVector:closestPointVector];
        return closestPoint;
    }
    
}

+(bool) isUserOrientation: (E20Matrix*) orientation linedUpWithLine:(E20MapLine*) line{
    E20Matrix * vec1 = line.getLineVector;
    double dot = [vec1 get2x1VectorDotProductWith:orientation]/vec1.get2x1VectorMagnitude/orientation.get2x1VectorMagnitude;
    dot = ABS(dot);
    double angle = acos(dot)*180/(double)M_PI;
    if(angle < 40){
        return YES;
    }
    return NO;
}

+(E20Matrix*) snapOrientation: (E20Matrix*) orientation toLine:(E20MapLine*) line{
    E20Matrix* vec1 = line.getLineVector;
    double dot = [vec1 get2x1VectorDotProductWith:orientation]/vec1.get2x1VectorMagnitude/orientation.get2x1VectorMagnitude;
    vec1 = [vec1 multiply2x1MatrixWithScalar:1/vec1.get2x1VectorMagnitude];
    if(dot<0){
        return [vec1 multiply2x1MatrixWithScalar:-1];
    }
    return vec1;
}

+(int) returnAreaFromUserPositionX: (double) x PositionY:(double) y mapAreas: (NSMutableArray*) mapAreas{
    for(int i=0;i<[mapAreas count];i++) {
        E20MapArea* area = [mapAreas objectAtIndex:i];
        E202dMapPoint* mapPoint = [[E202dMapPoint alloc] initWithPositionX:x andPositionY:y];
        if([E20MapInfo isPoint:mapPoint InsideMapArea:area]){
            return i;
        }
    }
    return -1; //error no map found, return -1
}

+(int) returnKeyFromUserPosition: (E202dMapPoint*) position  mapAreas: (NSMutableArray*) mapAreas{
    for(int i=0;i<[mapAreas count];i++) {
        E20MapArea* area = [mapAreas objectAtIndex:i];
        if([E20MapInfo isPoint:position InsideMapArea:area]){
            return i;
        }
    }
    return -1; //error no map found, return -1
}

@end

