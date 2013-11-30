//
//  E20StepDetectionViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/16/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20StepDetectionViewController.h"

@interface E20StepDetectionViewController ()


@end

@implementation E20StepDetectionViewController

# define filterLength 101
# define samplingFreq 101
# define numSamplesStored 101

@synthesize gravHistory;
@synthesize accelHistory;
@synthesize gyroHistory;
@synthesize sensorInfoData;
@synthesize keySensorInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startStepDetect
{
    
    
    
    self.motionManager.deviceMotionUpdateInterval = 1/150.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            NSArray *filterParam = [NSArray arrayWithObjects:
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
                            NSTimeInterval deltaT = currTime-prevTime; //time elapsed since last sensor interrupt
                            NSLog(@"Time: %f", deltaT);
                            
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.gravity.x;
                            dataPoint.y = data.gravity.y;
                            dataPoint.z = data.gravity.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [gravHistory addObject:dataPoint];
                            if([accelHistory count]>1){
                                //planarize the accel vector in the direction of grav
                                //using same function that planarizes gyro omega parallel to grav
                                E201dDataPoint* keySensorPoint = [E20SensorInfo getAccelPlanarizedForGrav:gravHistory ForAccel:accelHistory];
                                [keySensorInfo addObject:keySensorPoint];
                                if([keySensorInfo count]>filterLength){
                                    [keySensorInfo removeObjectAtIndex:0];
                                }
                            }
                            if([gravHistory count] > filterLength){
                                [gravHistory removeObjectAtIndex:0];
                                if([gyroHistory count] >= filterLength && [accelHistory count] >= filterLength && [keySensorInfo count]>=filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    int orient = [E20SensorInfo getPhoneOrientationWithRespectToGravity:gravHistory];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:gravHistory withFilterParam:filterParam forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:gyroHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroRaw forFilteredData:sensorInfoData.gyroFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:accelHistory withFilterParam:filterParam forRawData:sensorInfoData.accelRaw forFilteredData:sensorInfoData.accelFiltered];
                                    [E20SensorInfo set1dRawAndFilteredValueWithInput:keySensorInfo withFilterParam:filterParam forRawData:sensorInfoData.accelKeySensorRaw forFilteredData:sensorInfoData.accelKeySensorFiltered];
                                    if([sensorInfoData.accelKeySensorFiltered count]>2){
                                        bool step = NO;
                                        if (orient==0){
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam0];
                                        }
                                        if (orient==1){
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam1];
                                        }
                                        if (orient==2){
                                            step = [E20SensorInfo updateStepsDetectedUsingKeyAccelRaw:sensorInfoData.accelKeySensorRaw keyAccelFiltered:sensorInfoData.accelKeySensorFiltered rawAcceleration:sensorInfoData.accelRaw andStepParam:stepsParam2];
                                        }
                                        if(step == YES){
                                            _StepsTotal++;
                                            NSString * stepsDisplayString = [NSString stringWithFormat:@"%d", _StepsTotal];
                                            _TotalStepsText.text = stepsDisplayString;

                                        }
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
                            
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.rotationRate.x;
                            dataPoint.y = data.rotationRate.y;
                            dataPoint.z = data.rotationRate.z;
                            
                            [gyroHistory addObject:dataPoint];
                            if ([gyroHistory count]>filterLength)
                            {
                                [gyroHistory removeObjectAtIndex:0];
                            }
                            
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
                            E203dDataPoint *dataPoint = [[E203dDataPoint alloc] init];
                            dataPoint.x = data.acceleration.x;
                            dataPoint.y = data.acceleration.y;
                            dataPoint.z = data.acceleration.z;

                             [accelHistory addObject:dataPoint];
                            if ([accelHistory count]>filterLength)
                            {
                                [accelHistory removeObjectAtIndex:0];
                            }
                            
                        }
                        );
     }
     ];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)StartDectecting:(id)sender {

    [self setGravHistory:[[NSMutableArray alloc] init]];
    [self setGyroHistory:[[NSMutableArray alloc] init]];
    [self setAccelHistory:[[NSMutableArray alloc] init]];
    [self setKeySensorInfo:[[NSMutableArray alloc] init]];
    _StepsTotal = 0;
    NSString * stepsDisplayString = [NSString stringWithFormat:@"%d", _StepsTotal];
    _TotalStepsText.text = stepsDisplayString;
    sensorInfoData = [[E20SensorInfo alloc] init];
    [self startStepDetect];

    
}
- (IBAction)StopDetecting:(id)sender {
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];

}
@end
