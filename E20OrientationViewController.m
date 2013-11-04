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
                            [orientationView setCanDraw:YES];
                            E203dDataPoint *dataPoint;
                            dataPoint.x = data.gravity.x;
                            dataPoint.y = data.gravity.y;
                            dataPoint.z = data.gravity.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [orientationView.gravHistory addObject:dataPoint];
                            if([orientationView.gravHistory count] > filterLength){
                                [orientationView.gravHistory removeObjectAtIndex:0];
                                if([orientationView.gyroHistory count] >= filterLength && [orientationView.accelHistory count] >= filterLength){
                                    //check if it's ok to start filtering signals, as I'd like all of them to be synchronized with enough
                                    //data points
                                    [E20SensorInfo setRawAndFilteredValueWithInput:orientationView.gravHistory withFilterParam:filterParam forRawData:sensorInfoData.gravRaw forFilteredData:sensorInfoData.gravFiltered];
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
                            [orientationView setCanDraw:YES];
                            E203dDataPoint *dataPoint;
                            dataPoint.x = data.rotationRate.x;
                            dataPoint.y = data.rotationRate.y;
                            dataPoint.z = data.rotationRate.z;
                            dataPoint.timeStamp = currTime-prevTime;
                            [orientationView.gyroHistory addObject:dataPoint];
                            if([orientationView.gyroHistory count] > filterLength){
                                [orientationView.gyroHistory removeObjectAtIndex:0];
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
                            E203dDataPoint *dataPoint;
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
//    [self.scrollView setScrollEnabled:YES];
//    [self.scrollView setContentSize:(CGSizeMake(500, 500))];
//    
//    [orientationView setCanDraw:NO];
    

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

}

- (IBAction)stopOrientation:(id)sender {
}

- (IBAction)resetOrientation:(id)sender {
}
@end
