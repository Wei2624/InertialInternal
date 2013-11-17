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
                                                    [NSNumber numberWithDouble:0.47733],
                                                    [NSNumber numberWithDouble:0.66299],
                                                    [NSNumber numberWithDouble:samplingFreq],nil];

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
                            if([gravHistory count] > filterLength){
                                [gravHistory removeObjectAtIndex:0];
                                if([gyroHistory count] >= filterLength && [accelHistory count] >= filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:gravHistory withFilterParam:filterParam forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:gyroHistory withFilterParam:filterParam forRawData:sensorInfoData.gyroRaw forFilteredData:sensorInfoData.gyroFiltered];
                                    [E20SensorInfo set3dRawAndFilteredValueWithInput:accelHistory withFilterParam:filterParam forRawData:sensorInfoData.accelRaw forFilteredData:sensorInfoData.accelFiltered];
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
                            
                            [gyroHistory addObject:data];
                            if ([gyroHistory count]>numSamplesStored)
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
                            [accelHistory addObject:data];
                            if ([accelHistory count]>numSamplesStored)
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

    sensorInfoData = [[E20SensorInfo alloc] init];

    
}
- (IBAction)StopDetecting:(id)sender {
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];

}
@end
