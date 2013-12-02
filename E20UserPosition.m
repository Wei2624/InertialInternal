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
    }
    return self;
}

-(void) updatePositionForArea: (NSMutableDictionary*) mapAreas{
    E20Matrix* savedPosition = self.position.position.returnSelfCopy;
    double** data =self.position.position.data;
    double** data2 =self.orientation.data;
    data[0][0] += data2[0][0]*5;
    data[1][0] += data2[1][0]*5;
    if(1){
        if(![self isUserInArea:[mapAreas objectForKey:self.currentArea]]){
            NSMutableArray* mapYourIn = [self returnCurrentAreaInMap:mapAreas];
            if(mapYourIn == nil){//
                self.position.position = savedPosition;
                self.weight = self.weight/5;
            }
            else{
                E20MapLine* closestLineToOldArea = [E20MapInfo closestLineOnMap:[mapAreas objectForKey:self.currentArea] toPointOutsideMap:self.position];
                NSLog(@"%f , %f , %f , %f",closestLineToOldArea.startPosition.position.data[0][0],closestLineToOldArea.startPosition.position.data[0][1],closestLineToOldArea.startPosition.position.data[1][0],closestLineToOldArea.startPosition.position.data[1][1]);
                if(!closestLineToOldArea.crossable && ![E20MapInfo isUserOrientation:self.orientation linedUpWithLine:closestLineToOldArea]){
                    self.position.position = savedPosition;
                    self.weight = self.weight/3;
                }
                else if([E20MapInfo isUserOrientation:self.orientation linedUpWithLine:closestLineToOldArea]){
                    self.orientation = [E20MapInfo snapOrientation:self.orientation toLine:closestLineToOldArea];
                    self.position.position = savedPosition;
                    data =self.position.position.data;
                    data2 =self.orientation.data;
                    data[0][0] += data2[0][0]*5;
                    data[1][0] += data2[1][0]*5;
                    self.weight=self.weight/2;
                    
                }
                else {
                    self.currentArea = [self returnKeyForMap:mapYourIn forMapDict:mapAreas];
                }
            }
        }
    }
}

-(bool) isUserInArea: (NSMutableArray*) mapArea{
    return [E20MapInfo isPoint:self.position InsideMapArea:mapArea];
}

-(id) returnKeyForMap: (NSMutableArray*) area forMapDict: (NSMutableDictionary*) mapAreas{
    for(id key in mapAreas) {
        NSMutableArray* temp = [mapAreas objectForKey:key];
        if(area == temp){
            return key;
        }
    }
    return nil;
}

-(NSMutableArray*) returnCurrentAreaInMap: (NSMutableDictionary*) mapAreas{
    for(id key in mapAreas) {
        NSMutableArray* temp = [mapAreas objectForKey:key];
        if([E20MapInfo isPoint:self.position InsideMapArea:temp]){
            return temp;
        }
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
