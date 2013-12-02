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
@property NSString* currentArea;
@property E20Matrix* orientation;
@property double weight;
@property int updateOrder;
@property int numTimesUpdated;

-(id) initWithPosition: (E20Matrix*) position withOrientation: (E20Matrix*) orientation currentArea: (NSString*) area;

-(id) initWithPositionX: (double) x positionY: (double) y withOrientationAngle: (double) orientationAngle currentArea: (NSString*) area;

-(void) updatePositionForArea: (NSMutableDictionary*) mapAreas;
-(void) updateOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint;
-(NSMutableArray*) returnCurrentAreaInMap: (NSMutableDictionary*) mapAreas;
-(id) returnKeyForMap: (NSMutableArray*) area forMapDict: (NSMutableDictionary*) mapAreas;
-(bool) isUserInArea: (NSMutableArray*) mapArea;

@end
