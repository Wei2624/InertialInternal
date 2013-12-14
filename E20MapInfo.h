//
//  E20MapInfo.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E20MapArea.h"

@interface E20MapInfo : NSObject

+(bool) isPoint: (E202dMapPoint*) position InsideMapArea: (E20MapArea*) mapArea;
+(bool) doTheyIntersectLine1: (E20MapLine*) line1 andLine2: (E20MapLine*) line2;
+(double) closestDistanceFromPoint: (E202dMapPoint*) position ToLine: (E20MapLine*) line;
+(E202dMapPoint*) closestPointOnLine: (E20MapLine*) line toPoint:(E202dMapPoint*) position;
+(E202dMapPoint*) closestPointOnMapArea: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position;
+(double) closestDistanceToMap: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position;
+(bool) isUserOrientation: (E20Matrix*) orientation linedUpWithLine:(E20MapLine*) line;
+(E20Matrix*) snapOrientation: (E20Matrix*) orientation toLine:(E20MapLine*) line;
+(E20MapLine*) closestLineOnMap: (E20MapArea*) mapArea toPointOutsideMap:(E202dMapPoint*) position;
+(int) returnKeyFromUserPositionX: (double) x PositionY:(double) y mapAreas: (NSMutableArray*) mapAreas;
+(int) returnKeyFromUserPosition: (E202dMapPoint*) position  mapAreas: (NSMutableArray*) mapAreas;

@end
