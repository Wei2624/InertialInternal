//
//  E20OrientationViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20OrientationViewController.h"



@interface E20OrientationViewController ()
  @property  bool recordSensors;

@end

@implementation E20OrientationViewController

# define filterLength 101
# define samplingFreq 101

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
                            [orientationView.gravHistory addObject:dataPoint];
                            if (self.recordSensors==YES) {
                                if([orientationView.gravHistory count] > 0 && [orientationView.accelHistory count] > 0 && [orientationView.gyroHistory count] > 0)
                                {
                                    E203dDataPoint *lastGrav = [orientationView.gravHistory objectAtIndex:[orientationView.gravHistory count]-1];
                                    E203dDataPoint *lastAccel = [orientationView.accelHistory objectAtIndex:[orientationView.accelHistory count]-1];
                                    E203dDataPoint *lastGyro = [orientationView.gyroHistory objectAtIndex:[orientationView.gyroHistory count]-1];
                                    
                                    [orientationView.csvOutput appendFormat:@"\n%f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f",dataPoint.timeStamp,lastGyro.x,lastGyro.y,lastGyro.z,lastGrav.x,lastGrav.y,lastGrav.z,lastAccel.x,
                                     lastAccel.y,lastAccel.z];
                                    
                                }
                            }

                            if([orientationView.gravHistory count] > filterLength){
                                [orientationView.gravHistory removeObjectAtIndex:0];
                                if([orientationView.gyroHistory count] >= filterLength && [orientationView.accelHistory count] >= filterLength && [orientationView.gyroPlanarizedHistory count] >=filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.gravHistory withFilterParam:filterParam forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.gyroHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroRaw forFilteredData:sensorInfoData.gyroFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:orientationView.accelHistory withFilterParam:filterParam forRawData:sensorInfoData.accelRaw forFilteredData:sensorInfoData.accelFiltered];
                                    [E20SensorInfo set1dRawAndFilteredValueWithInput:orientationView.gyroPlanarizedHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroPlanarizedRaw forFilteredData:sensorInfoData.gyroPlanarizedFiltered];
                                    if([sensorInfoData.gyroPlanarizedFiltered count]>= maxSensorHistoryStored){
                                        orientationView.canDraw = YES;
                                        E201dDataPoint* gyroPlanarizedRawPoint = [sensorInfoData.gyroPlanarizedRaw objectAtIndex:0];
                                        E201dDataPoint* gyroWhittakerPoint;
                                        int phoneOrientation = gyroPlanarizedRawPoint.phoneOrientation;
                                        if(phoneOrientation ==0){
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam0 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                        else if(phoneOrientation ==1){
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam1 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                        else{
                                            gyroWhittakerPoint =[E20SensorInfo updateGyroWhittaker:sensorInfoData.gyroWhittaker WithParam:whittParam2 forGyroPlanarizedRaw:sensorInfoData.gyroPlanarizedRaw forGyroPlanarizedFiltered:sensorInfoData.gyroPlanarizedFiltered];
                                        }
                                        [orientationView.gyroWhitt addObject:gyroWhittakerPoint];
                                        if([orientationView.gyroWhitt count]>filterLength){
                                            [orientationView.gyroWhitt removeObjectAtIndex:0];
                                        }
                                        E201dDataPoint* gyroPlanarizedFilteredPoint = [sensorInfoData.gyroPlanarizedFiltered objectAtIndex:0];
                                        if (self.recordSensors==YES) {
                                            [orientationView.csvOutput2 appendFormat:@"\n%f,%1.2f,%1.2f,%1.2f",gyroPlanarizedRawPoint.timeStamp,gyroPlanarizedRawPoint.value,gyroPlanarizedFilteredPoint.value,gyroWhittakerPoint.value];
                                            
                                        }
                                        [orientationView updateOrientationVectorWithPlanarizedGyroPoint:[sensorInfoData.gyroWhittaker objectAtIndex:[sensorInfoData.gyroWhittaker count]-1]];
                                    }

                                }
                               // NSLog(@"%lu, %lu, %lu, %lu, %f",[sensorInfoData.gravFiltered count],[sensorInfoData.gyroFiltered count],[sensorInfoData.accelFiltered count],[sensorInfoData.gyroWhittaker count],dataPoint.timeStamp);
                            }
                            prevTime = currTime;
                            [orientationView setNeedsDisplay];
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
    self.recordSensors = NO;
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
    [orientationView setGyroWhitt:[[NSMutableArray alloc] init]];
    [orientationView setPositionHistory:[[NSMutableArray alloc] init]];
    double vector[2];
    vector[0] = 0;
    vector[1] = 1;
    [orientationView setOrientationVector:[[E20Matrix alloc] initMatrixVectorWithRows:2 andVectorData:vector]];
    vector[0] = 350;
    vector[1] = 350;
    [orientationView setPositionVector:[[E20Matrix alloc] initMatrixVectorWithRows:2 andVectorData:vector]];
    sensorInfoData = [[E20SensorInfo alloc] init];
    if (self.recordSensors==YES) {
        orientationView.csvOutput = [NSMutableString stringWithString:@"Time,GyroX,GyroY,GyroZ,GravX,GravY,GravZ,AccelX,AccelY,AccelZ"];
        orientationView.csvOutput2 = [NSMutableString stringWithString:@"Time,GyroPlanarizedRaw,GyroPlanarizedFiltered,GyroWhittaker"];
    }
}

- (IBAction)stopOrientation:(id)sender {
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
    if (self.recordSensors==YES) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath= nil;
        NSDate *myDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *myDateString = [dateFormatter stringFromDate:myDate];
        
        filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[myDateString stringByAppendingString:@".csv"]];
        NSData* settingsData;
        settingsData = [orientationView.csvOutput dataUsingEncoding: NSASCIIStringEncoding];
        
        if ([settingsData writeToFile:filePath atomically:YES])
            NSLog(@"writeok");
        
        filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[myDateString stringByAppendingString:@"_2.csv"]];
        settingsData = [orientationView.csvOutput2 dataUsingEncoding: NSASCIIStringEncoding];
        
        if ([settingsData writeToFile:filePath atomically:YES])
            NSLog(@"writeok");
    }

}


- (IBAction)resetOrientation:(id)sender {
}
@end
