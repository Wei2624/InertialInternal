//
//  E20OrientationGraphView.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "E20SensorInfo.h"
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"
#import "E20Matrix.h"


@interface E20OrientationGraphView : UIView

@property (nonatomic,assign) BOOL canDraw;
@property (nonatomic,strong) NSMutableArray* gravHistory;
@property (nonatomic,strong) NSMutableArray* accelHistory;
@property (nonatomic,strong) NSMutableArray* gyroHistory;
@property (nonatomic,strong) NSMutableArray* gyroPlanarizedHistory;
@property (nonatomic,strong) NSMutableArray* gyroWhitt; //debug puposes copied from sensorinfo to display
@property (nonatomic,strong) NSMutableArray* positionHistory;

@property (nonatomic, strong) E20Matrix* orientationVector;
@property (nonatomic, strong) E20Matrix* positionVector;

@property (nonatomic,strong) NSMutableString* csvOutput; //general grav,gyro,accel data straight form sensors
@property (nonatomic,strong) NSMutableString* csvOutput2; //gyroplanarized raw and filtered and whittaker point


-(void) updateOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint;


@end
