//
//  E20UserPosition.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20UserPosition.h"

@implementation E20UserPosition

-(id) initWithPosition: (E20Matrix*) position withOrientation: (E20Matrix*) orientation currentArea: (NSString*) area{
    self = [super init];
    if(self){
        self.position = [[E202dMapPoint alloc] initWith2x1MatrixVector:position.returnSelfCopy];
        self.orientation = orientation.returnSelfCopy;
        self.currentArea = area;
        self.weight = 100;
        self.updateOrder = ( (arc4random() % (3-0+1)) + 0 );
        self.numTimesUpdated = 0;
        self.rebreadthCounter = 10;
        self.rebreadthSpawned=NO;
    }
    return self;
    
}

-(id) initWithPositionX: (double) x positionY: (double) y withOrientationAngle: (double) orientationAngle currentArea: (NSString*) area{
    self = [super init];
    if(self){
        self.position = [[E202dMapPoint alloc] initWithPositionX:x andPositionY:y];
        double xOrient = cos(orientationAngle*M_PI/180);
        double yOrient = sin(orientationAngle*M_PI/180);
        self.orientation = [[E20Matrix alloc] initMatrix2x1VectorWithX:xOrient andY:yOrient];
        self.currentArea = area;
        self.weight = 100;
        self.updateOrder = ( (arc4random() % (3-0+1)) + 0 );
        self.numTimesUpdated=0;
        self.rebreadthCounter=10;
        self.rebreadthSpawned=NO;
    }
    return self;
}

-(E20MapLine*) updatePositionForArea: (NSMutableArray*) mapAreas{
    /*returns closest line if it sees that it is hitting into wall perpendicularly and wants to spread to see if there is an opening
    ||<**
    ||<***
    ||<**
    ||
    --
    --
    ||
    ||
    ||
    */
    self.rebreadthCounter--;
    E20Matrix* savedPosition = self.position.position.returnSelfCopy;
    double** data =self.position.position.data;
    double** data2 =self.orientation.data;
    data[0][0] += data2[0][0]*4;
    data[1][0] += data2[1][0]*4;
    NSLog(@"OP: %f , %f",savedPosition.data[0][0],savedPosition.data[1][0]);
    NSLog(@"NP: %f , %f",data[0][0],data[1][0]);
    NSLog(@"Orient: %f , %f",self.orientation.data[0][0],self.orientation.data[1][0]);
    if(![E20MapInfo isPoint:self.position InsideMapArea:[mapAreas objectAtIndex:self.currArea]]){
        E20MapLine* closestLine = [E20MapInfo closestLineOnMap:[mapAreas objectAtIndex:self.currArea] toPointOutsideMap:self.position];
        NSLog(@"Orient: %f , %f ,%f ,%f",closestLine.startPosition.position.data[0][0],closestLine.startPosition.position.data[1][0],closestLine.endPosition.position.data[0][0],closestLine.endPosition.position.data[1][0]);
        int currArea = [E20MapInfo returnKeyFromUserPosition:self.position mapAreas:mapAreas];
        if([E20MapInfo isUserOrientation:self.orientation linedUpWithLine:closestLine]&&currArea==-1){
            self.weight=self.weight/3;
            self.position.position=savedPosition;
        }
        else if (currArea==-1){ //-1 represents no map area found
            self.weight=self.weight/5;
            self.position.position=savedPosition;
            return closestLine;
            
        }
        else{
            self.currArea = currArea;
        }
    }
    return nil;
}

-(bool) isUserInArea: (E20MapArea*) mapArea{
    return [E20MapInfo isPoint:self.position InsideMapArea:mapArea];
}

-(int) returnIntKeyForMap: (E20MapArea*) area forMapAreas: (NSMutableArray*) mapAreas{
    for(int i=0;i<[mapAreas count];i++) {
        E20MapArea* temp = [mapAreas objectAtIndex:i];
        if(area == temp){
            return i;
        }
    }
    return -1;
}

-(E20MapArea*) returnCurrentAreaInMap: (NSMutableArray*) mapAreas{
    int area= [E20MapInfo returnKeyFromUserPosition:self.position mapAreas:mapAreas];
    if(area>=0){
        return [mapAreas objectAtIndex:area];
    }
    return nil;
}

-(void) updateOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint{
    double theta = gyroPlanarizedPoint.value; //already multiplied when creating planarizedgyro
    if(abs(gyroPlanarizedPoint.value)>0.1){
        theta = theta;
    }
    double Rot[2][2];
    Rot[0][0] =Rot[1][1]= cos(theta);
    Rot[0][1] = -sin(theta);
    Rot[1][0] = sin(theta);
    double x = self.orientation.data[0][0];
    double y = self.orientation.data[1][0];
    double x1 = Rot[0][0]*x+Rot[0][1]*y;
    double y1 = Rot[1][0]*x+Rot[1][1]*y;
    self.orientation.data[0][0] = x1;
    self.orientation.data[1][0] = y1;
}

@end
