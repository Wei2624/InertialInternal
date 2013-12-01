//
//  E20EatonCenterViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20EatonCenterViewController.h"

@interface E20EatonCenterViewController ()

@end

@implementation E20EatonCenterViewController
# define filterLength 101
# define samplingFreq 101
# define numSamplesStored 101


@synthesize eatonMapView;
@synthesize sensorInfoData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startMotionTracking
{
    
    
    
    self.motionManager.deviceMotionUpdateInterval = 1/150.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            /*PPPLLLLEEEEEAAASEEE break this block down into subfunctions*/
                            NSArray *filterParamGyro = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:0.466222],
                                                    [NSNumber numberWithDouble:0.684419],
                                                    [NSNumber numberWithDouble:samplingFreq],nil];
                            NSArray *whittParam0 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:302],
                                                    [NSNumber numberWithInt:63],
                                                    [NSNumber numberWithDouble:0.007914],
                                                    [NSNumber numberWithInt:315],nil];
                            NSArray *whittParam1 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:599.946],
                                                    [NSNumber numberWithInt:4],
                                                    [NSNumber numberWithDouble:0.022104],
                                                    [NSNumber numberWithInt:302],nil];
                            NSArray *whittParam2 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:601.5476],
                                                    [NSNumber numberWithInt:4],
                                                    [NSNumber numberWithDouble:0.007754],
                                                    [NSNumber numberWithInt:344.7508],nil];
                            
                            NSArray *filterParamSteps = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:1],
                                                    [NSNumber numberWithDouble:1.1],
                                                    [NSNumber numberWithDouble:samplingFreq],nil];
                            
                            NSArray *stepsParam0 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:40],
                                                    [NSNumber numberWithDouble:0.002],
                                                    [NSNumber numberWithDouble:0.03],
                                                    [NSNumber numberWithDouble:0.008],
                                                    [NSNumber numberWithDouble:0.16],
                                                    [NSNumber numberWithDouble:4.369e-7],
                                                    [NSNumber numberWithDouble:3e-4],nil];
                            
                            NSArray *stepsParam1 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:40],
                                                    [NSNumber numberWithDouble:9.375e-4],
                                                    [NSNumber numberWithDouble:5e-3],
                                                    [NSNumber numberWithDouble:4.9e-3],
                                                    [NSNumber numberWithDouble:3e-2],
                                                    [NSNumber numberWithDouble:2.73e-7],
                                                    [NSNumber numberWithDouble:7e-6],nil];
                            
                            NSArray *stepsParam2 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:40],
                                                    [NSNumber numberWithDouble:7.6e-4],
                                                    [NSNumber numberWithDouble:3.5e-3],
                                                    [NSNumber numberWithDouble:2.3e-3],
                                                    [NSNumber numberWithDouble:0.023],
                                                    [NSNumber numberWithDouble:2.532e-7],
                                                    [NSNumber numberWithDouble:6e-6],nil];

                            static NSTimeInterval prevTime; //holds the timestamp of the last sensor interrupt
                            static dispatch_once_t once;
                            dispatch_once(&once, ^{
                                prevTime = data.timestamp;
                            });
                            NSTimeInterval currTime = data.timestamp;
                            
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.gravity.x;
                            dataPoint.y = data.gravity.y;
                            dataPoint.z = data.gravity.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            NSLog(@"Time: %f", currTime-prevTime);
                            [eatonMapView.gravHistory addObject:dataPoint];
                            if([eatonMapView.accelHistory count]>1){
                                //planarize the accel vector in the direction of grav
                                //using same function that planarizes gyro omega parallel to grav
                                E201dDataPoint* keySensorPoint = [E20SensorInfo getAccelPlanarizedForGrav:eatonMapView.gravHistory ForAccel:eatonMapView.accelHistory];
                                [eatonMapView.keySensorInfo addObject:keySensorPoint];
                                if([eatonMapView.keySensorInfo count]>filterLength){
                                    [eatonMapView.keySensorInfo removeObjectAtIndex:0];
                                }
                            }

                            
                            if([eatonMapView.gravHistory count] > filterLength){
                                [eatonMapView.gravHistory removeObjectAtIndex:0];
                                if([eatonMapView.gyroHistory count] >= filterLength && [eatonMapView.accelHistory count] >= filterLength && [eatonMapView.gyroPlanarizedHistory count] >=filterLength && [eatonMapView.keySensorInfo count]>= filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:eatonMapView.gravHistory withFilterParam:filterParamGyro forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:eatonMapView.gyroHistory withFilterParam:filterParamGyro forRawData:sensorInfoData.gyroRaw forFilteredData:sensorInfoData.gyroFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:eatonMapView.accelHistory withFilterParam:filterParamGyro forRawData:sensorInfoData.accelRaw forFilteredData:sensorInfoData.accelFiltered];
                                    [E20SensorInfo set1dRawAndFilteredValueWithInput:eatonMapView.gyroPlanarizedHistory withFilterParam:filterParamGyro forRawData:sensorInfoData.gyroPlanarizedRaw forFilteredData:sensorInfoData.gyroPlanarizedFiltered];
                                    [E20SensorInfo set1dRawAndFilteredValueWithInput:eatonMapView.keySensorInfo withFilterParam:filterParamSteps forRawData:sensorInfoData.accelKeySensorRaw forFilteredData:sensorInfoData.accelKeySensorFiltered];
                                    if([sensorInfoData.gyroPlanarizedFiltered count]>= maxSensorHistoryStored){
                                        
                                        E201dDataPoint* gyroPlanarizedRawPoint = [sensorInfoData.gyroPlanarizedRaw objectAtIndex:0];
                                        E201dDataPoint* gyroWhittakerPoint;
                                        int phoneOrientation = gyroPlanarizedRawPoint.phoneOrientation;
                                        bool step= NO;
                                        if(phoneOrientation ==0){
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam0 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                            
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam0];
                                        }
                                        else if(phoneOrientation ==1){
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam1 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                            
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam1];
                                        }
                                        else{
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam2 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam2];
                                        }
                                        
                                        [eatonMapView.user1 updateOrientationVectorWithPlanarizedGyroPoint:[sensorInfoData.gyroWhittaker objectAtIndex:[sensorInfoData.gyroWhittaker count]-1]];
                                        
                                        if(step == YES){
                                            [eatonMapView.user1 updatePositionForArea:eatonMapView.eatonAreas];
                                            [eatonMapView setNeedsDisplay];
                                        }
                                        //update oreitnation
                                    }
                                    
                                }
                                
                            }
                            prevTime = currTime;
                            
                        }
                            );
     }
     ];
    
    self.motionManager.gyroUpdateInterval = 1/150.0f;
    [self.motionManager
     startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMGyroData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            static NSTimeInterval prevTime; //holds the timestamp of the last sensor interrupt
                            static dispatch_once_t once;
                            dispatch_once(&once, ^{
                                prevTime = data.timestamp;
                                
                            });
                            NSTimeInterval currTime = data.timestamp;
                            
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.rotationRate.x;
                            dataPoint.y = data.rotationRate.y;
                            dataPoint.z = data.rotationRate.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [eatonMapView.gyroHistory addObject:dataPoint];
                            if([eatonMapView.gyroHistory count] > filterLength){
                                [eatonMapView.gyroHistory removeObjectAtIndex:0];
                            }
                            if([eatonMapView.gravHistory count] >0){
                                E201dDataPoint *gyroPlanarizedPoint = [E20SensorInfo getGyroPlanarizedForGrav:eatonMapView.gravHistory ForGyro:eatonMapView.gyroHistory];
                                [eatonMapView.gyroPlanarizedHistory addObject:gyroPlanarizedPoint];
                                if([eatonMapView.gyroPlanarizedHistory count]>filterLength){
                                    [eatonMapView.gyroPlanarizedHistory removeObjectAtIndex:0];
                                }
                            }
                            prevTime = currTime;
                        }
                        );
     }
     ];
    
    self.motionManager.accelerometerUpdateInterval = 1/150.0f;
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            static NSTimeInterval prevTime; //holds the timestamp of the last sensor interrupt
                            static dispatch_once_t once;
                            dispatch_once(&once, ^{
                                prevTime = data.timestamp;
                                
                            });
                            NSTimeInterval currTime = data.timestamp;
                            
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.acceleration.x;
                            dataPoint.y = data.acceleration.y;
                            dataPoint.z = data.acceleration.z;
                            dataPoint.timeStamp = currTime - prevTime;
                            [eatonMapView.accelHistory addObject:dataPoint];
                            if([eatonMapView.accelHistory count] > filterLength){
                                [eatonMapView.accelHistory removeObjectAtIndex:0];
                            }
                            prevTime = currTime;
                        }
                        );
     }
     ];
    
    
}

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:(CGSizeMake(800, 1300))];
    [self loadData];
    self.eatonMapView.canDraw = YES;
    [eatonMapView setNeedsDisplay];
    eatonMapView.user1 =[[E20UserPosition alloc] initWithPositionX:200 positionY:160 withOrientationAngle:90 currentArea:[NSString stringWithFormat:@"area%d.csv",0]];
    [eatonMapView setGravHistory:[[NSMutableArray alloc] init]];
    [eatonMapView setGyroHistory:[[NSMutableArray alloc] init]];
    [eatonMapView setAccelHistory:[[NSMutableArray alloc] init]];
    [eatonMapView setGyroPlanarizedHistory:[[NSMutableArray alloc] init]];
    [eatonMapView setGyroWhitt:[[NSMutableArray alloc] init]];
    [eatonMapView setPositionHistory:[[NSMutableArray alloc] init]];
    [eatonMapView setKeySensorInfo:[[NSMutableArray alloc] init]];
    [self setSensorInfoData:[[E20SensorInfo alloc] init]];
    [self startMotionTracking];


	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData{
    eatonMapView.eatonAreas = [[NSMutableDictionary alloc]init];
    NSMutableArray * newMapLine;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath= nil;
    filePath = [documentsDirectoryPath  stringByAppendingPathComponent:@"mainCorridor.csv"];
    

    NSError *error;
    NSString *stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:filePath
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    
    NSArray  *lines  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
    NSEnumerator*theEnum = [lines objectEnumerator];
    NSString *theLine;
    newMapLine = [[NSMutableArray alloc] init];
    while (nil != (theLine = [theEnum nextObject]) )
    {
        if (![theLine isEqualToString:@""] && ![theLine hasPrefix:@"#"])    // ignore empty lines and lines that start with #
        {
            NSArray    *values  = [theLine componentsSeparatedByString:@","];
            NSString *value = [values objectAtIndex:1];
            double x1 = [value doubleValue];
            value = [values objectAtIndex:2];
            double y1 = [value doubleValue];
            value = [values objectAtIndex:3];
            double x2 = [value doubleValue];
            value = [values objectAtIndex:4];
            double y2 = [value doubleValue];
            value = [values objectAtIndex:0];
            int crossable = [value intValue];
            bool cross;
            if (crossable) {
                cross = YES;
            }
            else{
                cross = NO;
            }
            E20MapLine* newLine = [[E20MapLine alloc] initWithCartesianX1:x1 Y1:y1 X2:x2 Y2:y2 boolCrossable: cross];
            [newMapLine addObject:newLine];
        }
    }
    [eatonMapView.eatonAreas setValue:newMapLine forKey:[NSString stringWithFormat:@"area%d.csv",0]];
    
    for(int i=1;i<18;i++){
        filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"store%d.csv",i]];
        
        
        NSError *error;
        NSString *stringFromFileAtPath = [[NSString alloc]
                                          initWithContentsOfFile:filePath
                                          encoding:NSUTF8StringEncoding
                                          error:&error];
        
        NSArray  *lines  = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
        NSEnumerator*theEnum = [lines objectEnumerator];
        NSString *theLine;
        
        newMapLine = [[NSMutableArray alloc] init];
        while (nil != (theLine = [theEnum nextObject]) )
        {
            if (![theLine isEqualToString:@""] && ![theLine hasPrefix:@"#"])    // ignore empty lines and lines that start with #
            {
                NSArray    *values  = [theLine componentsSeparatedByString:@","];
                NSString *value = [values objectAtIndex:1];
                double x1 = [value doubleValue];
                value = [values objectAtIndex:2];
                double y1 = [value doubleValue];
                value = [values objectAtIndex:3];
                double x2 = [value doubleValue];
                value = [values objectAtIndex:4];
                double y2 = [value doubleValue];
                value = [values objectAtIndex:0];
                int crossable = [value intValue];
                bool cross;
                if (crossable) {
                    cross = YES;
                }
                else{
                    cross = NO;
                }
                E20MapLine* newLine = [[E20MapLine alloc] initWithCartesianX1:x1 Y1:y1 X2:x2 Y2:y2 boolCrossable: cross];
                [newMapLine addObject:newLine];
                
            }
        
            [eatonMapView.eatonAreas setValue:newMapLine forKey:[NSString stringWithFormat:@"area%d.csv",i]];
        }
            
    }
    

}

@end
