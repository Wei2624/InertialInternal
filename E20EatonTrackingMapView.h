//
//  E20EatonTrackingMapView.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20UserPosition.h"
#import "E20UserPosition.h"
#import "E20SensorInfo.h"
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"
#import "E20Matrix.h"
#import <CoreMotion/CoreMotion.h>

@interface E20EatonTrackingMapView : UIView

@property (nonatomic,assign) BOOL canDraw;
@property NSMutableDictionary* eatonAreas;
@property NSMutableArray* user1;
@property NSMutableArray* user2;
@property NSMutableArray* user3;
@property NSMutableArray* user4;
@property NSMutableArray* user5;
@property NSArray* user1History;
@property NSArray* user2History;
@property NSArray* user3History;
@property NSArray* user4History;
@property NSArray* user5History;

@end
