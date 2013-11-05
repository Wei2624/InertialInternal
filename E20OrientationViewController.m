//
//  E20OrientationViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20OrientationViewController.h"



@interface E20OrientationViewController ()


@end

@implementation E20OrientationViewController

# define filterLength 101
# define samplingFreq 100

@synthesize orientationView;
@synthesize sensorInfoData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startOrientationTracking
{
    
    
    
    self.motionManager.deviceMotionUpdateInterval = 1/150.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            /*PPPLLLLEEEEEAAASEEE break this block down into subfunctions*/
                            NSArray *filterParam = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:0.47733],
                                                    [NSNumber numberWithDouble:0.66299],
                                                    [NSNumber numberWithDouble:samplingFreq],nil];
                            NSArray *whittParam0 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:295.3554],
                                                    [NSNumber numberWithInt:38],
                                                    [NSNumber numberWithDouble:0.004762],
                                                    [NSNumber numberWithInt:298],nil];
                            NSArray *whittParam1 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:584.0116],
                                                    [NSNumber numberWithInt:23],
                                                    [NSNumber numberWithDouble:0.004351],
                                                    [NSNumber numberWithInt:300],nil];
                            NSArray *whittParam2 = [NSArray arrayWithObjects:
                                                    [NSNumber numberWithInteger:filterLength],
                                                    [NSNumber numberWithDouble:600.5476],
                                                    [NSNumber numberWithInt:37],
                                                    [NSNumber numberWithDouble:0.0022],
                                                    [NSNumber numberWithInt:441],nil];
                            static NSTimeInterval prevTime; //holds the timestamp of the last sensor interrupt
                            static dispatch_once_t once;
                            dispatch_once(&once, ^{
                                prevTime = data.timestamp;
                            });
                            NSTimeInterval currTime = data.timestamp;
                            [orientationView setCanDraw:YES];
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.gravity.x;
                            dataPoint.y = data.gravity.y;
                            dataPoint.z = data.gravity.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [orientationView.gravHistory addObject:dataPoint];
                            if([orientationView.gravHistory count] > filterLength){
                                [orientationView.gravHistory removeObjectAtIndex:0];
                                if([orientationView.gyroHistory count] >= filterLength && [orientationView.accelHistory count] >= filterLength && [orientationView.gyroPlanarizedHistory count] >=filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.gravHistory withFilterParam:filterParam forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.gyroHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroRaw forFilteredData:sensorInfoData.gyroFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.accelHistory withFilterParam:filterParam forRawData:sensorInfoData.accelRaw forFilteredData:sensorInfoData.accelFiltered];
                                    [E20SensorInfo set1dRawAndFilteredValueWithInput:orientationView.gyroPlanarizedHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroPlanarizedRaw forFilteredData:sensorInfoData.gyroPlanarizedFiltered];
                                    if([sensorInfoData.gyroFiltered count]>= maxSensorHistoryStored){
                                        E201dDataPoint* gyroPlanarizedRawPoint = [sensorInfoData.gyroPlanarizedRaw objectAtIndex:0];
                                        int phoneOrientation = gyroPlanarizedRawPoint.phoneOrientation;
                                        if(phoneOrientation ==0){
                                            [E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam0 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                        else if(phoneOrientation ==1){
                                            [E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam1 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                        else{
                                            [E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam2 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                    }

                                }
                                NSLog(@"%lu, %lu, %lu, %lu, %f",[sensorInfoData.gravFiltered count],[sensorInfoData.gyroFiltered count],[sensorInfoData.accelFiltered count],[sensorInfoData.gyroWhittaker count],dataPoint.timeStamp);
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
                            [orientationView setCanDraw:YES];
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.rotationRate.x;
                            dataPoint.y = data.rotationRate.y;
                            dataPoint.z = data.rotationRate.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [orientationView.gyroHistory addObject:dataPoint];
                            if([orientationView.gyroHistory count] > filterLength){
                                [orientationView.gyroHistory removeObjectAtIndex:0];
                            }
                            if([orientationView.gravHistory count] >0){
                                E201dDataPoint *gyroPlanarizedPoint = [E20SensorInfo getGyroPlanarizedForGrav:orientationView.gravHistory ForGyro:orientationView.gyroHistory];
                                [orientationView.gyroPlanarizedHistory addObject:gyroPlanarizedPoint];
                                if([orientationView.gyroPlanarizedHistory count]>filterLength){
                                    [orientationView.gyroPlanarizedHistory removeObjectAtIndex:0];
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
                            [orientationView setCanDraw:YES];
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.acceleration.x;
                            dataPoint.y = data.acceleration.y;
                            dataPoint.z = data.acceleration.z;
                            dataPoint.timeStamp = currTime - prevTime;
                            [orientationView.accelHistory addObject:dataPoint];
                            if([orientationView.accelHistory count] > filterLength){
                                [orientationView.accelHistory removeObjectAtIndex:0];
                            }
                            prevTime = currTime;
                        }
                        );
     }
     ];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:(CGSizeMake(500, 500))];
    
    [orientationView setCanDraw:NO];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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



- (IBAction)startOrientation:(id)sender {
    [self startOrientationTracking];
    [orientationView setCanDraw:NO];
    [orientationView setGravHistory:[[NSMutableArray alloc] init]];
    [orientationView setGyroHistory:[[NSMutableArray alloc] init]];
    [orientationView setAccelHistory:[[NSMutableArray alloc] init]];
    [orientationView setGyroPlanarizedHistory:[[NSMutableArray alloc] init]];
    sensorInfoData = [[E20SensorInfo alloc] init];

}

- (IBAction)stopOrientation:(id)sender {
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
}


- (IBAction)resetOrientation:(id)sender {
}
@end
