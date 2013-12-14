//
//  E20UserPosition.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E20MapInfo.h"

@interface E20UserPosition : NSObject

@property E202dMapPoint* position;
@property E20Matrix* orientation;
@property NSString* currentArea;
@property double weight;
@property int updateOrder;
@property int numTimesUpdated;
@property int currArea;
@property int rebreadthCounter;
@property bool rebreadthSpawned;


-(id) initWithPosition: (E20Matrix*) position withOrientation: (E20Matrix*) orientation currentArea: (NSString*) area;

-(id) initWithPositionX: (double) x positionY: (double) y withOrientationAngle: (double) orientationAngle currentArea: (NSString*) area;

-(E20MapLine*) updatePositionForArea: (NSMutableArray*) mapAreas; 
-(void) updateOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint;
-(E20MapArea*) returnCurrentAreaInMap: (NSMutableArray*) mapAreas;
-(int) returnIntKeyForMap: (E20MapArea*) area forMapAreas: (NSMutableArray*) mapAreas;
-(bool) isUserInArea: (NSMutableArray*) mapArea;

@end
