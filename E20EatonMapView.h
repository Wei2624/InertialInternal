//
//  E20EatonMapView.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20UserPosition.h"
#import "E20SensorInfo.h"
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"
#import "E20Matrix.h"
#import <CoreMotion/CoreMotion.h>

@interface E20EatonMapView : UIView

@property (nonatomic,assign) BOOL canDraw;
@property NSMutableDictionary* eatonAreas;

@property (nonatomic,strong) NSMutableArray* gravHistory;
@property (nonatomic,strong) NSMutableArray* accelHistory;
@property (nonatomic,strong) NSMutableArray* gyroHistory;
@property (nonatomic,strong) NSMutableArray* gyroPlanarizedHistory;
@property (nonatomic,strong) NSMutableArray* gyroWhitt; //debug puposes copied from sensorinfo to display
@property (nonatomic,strong) NSMutableArray* positionHistory;
@property (nonatomic,strong) NSMutableArray* keySensorInfo;  //stores the accel info dot producted with gravity



@property E20UserPosition* user1;



@end
