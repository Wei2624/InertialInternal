//
//  E20ViewController.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20ViewController.h"

@interface E20ViewController ()

@end

@implementation E20ViewController

const int numInertialValuesStored = 300;


@synthesize accelView;

-(void)startMyMotionDetect
{
    
    
    NSOperationQueue *nsqueue = [[NSOperationQueue alloc] init];
    [nsqueue setMaxConcurrentOperationCount:5];
    self.motionManager.deviceMotionUpdateInterval = 1/110.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [accelView setCanDraw:YES];
                            [accelView.gravHistory addObject:data];
                            if ([accelView.gravHistory count]>numInertialValuesStored)
                            {
                                [accelView.gravHistory removeObjectAtIndex:0];
                            }
                            [accelView setNeedsDisplay];
                            NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
                            NSLog(@"Time: %f", timeInMiliseconds);
                            CMDeviceMotion *lastGrav = [accelView.gravHistory objectAtIndex:[accelView.gravHistory count]-1];
                            CMAccelerometerData *lastAccel = [accelView.accelHistory objectAtIndex:[accelView.accelHistory count]-1];
                            CMGyroData *lastGyro = [accelView.gyroHistory objectAtIndex:[accelView.gyroHistory count]-1];

                            [accelView.csvOutput appendFormat:@"\n%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f",timeInMiliseconds,lastGrav.gravity.x,lastGrav.gravity.y,lastGrav.gravity.z,lastAccel.acceleration.x,
                             lastAccel.acceleration.y,lastAccel.acceleration.z,lastGyro.rotationRate.x,lastGyro.rotationRate.y,lastGyro.rotationRate.z];
//                            [accelView.csvOutput appendFormat:@"\n%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f",
//                             timeInMiliseconds,lastGrav.gravity.x,lastGrav.gravity.y,lastGrav.gravity.z,lastAccel.acceleration.x,
//                             lastAccel.acceleration.y,lastAccel.acceleration.z,lastGyro.rotationRate.x,lastGyro.rotationRate.y,
//                             ,lastGyro.rotationRate.z];
                            
                        }
                        );
     }
     ];
    
    self.motionManager.gyroUpdateInterval = 1/110.0f;
    [self.motionManager
     startGyroUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMGyroData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [accelView setCanDraw:YES];
                            [accelView.gyroHistory addObject:data];
                            if ([accelView.gyroHistory count]>numInertialValuesStored)
                            {
                                [accelView.gyroHistory removeObjectAtIndex:0];
                            }
                        }
                        );
     }
     ];

    self.motionManager.accelerometerUpdateInterval = 1/110.0f;
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [accelView setCanDraw:YES];
                            [accelView.accelHistory addObject:data];
                            if ([accelView.accelHistory count]>numInertialValuesStored)
                            {
                                [accelView.accelHistory removeObjectAtIndex:0];
                            }
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
    [accelView setCanDraw:NO];
    [accelView setGravHistory:[[NSMutableArray alloc] init]];
    [accelView setGyroHistory:[[NSMutableArray alloc] init]];
    [accelView setAccelHistory:[[NSMutableArray alloc] init]];
    _textBox.delegate = self;
    
    
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


- (IBAction)startButton:(id)sender {
    //self.textBox.text = [NSString stringWithFormat:@"Accel started"];
    [self startMyMotionDetect];
    accelView.csvOutput = [NSMutableString stringWithString:@"Time,GravX,GravY,GravZ,AccelX,AccelY,AccelZ,GyroX,GyroY,GyroZ"];
    [accelView setCanDraw:NO];
    [accelView setGravHistory:[[NSMutableArray alloc] init]];
    [accelView setGyroHistory:[[NSMutableArray alloc] init]];
    [accelView setAccelHistory:[[NSMutableArray alloc] init]];
    
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager startDeviceMotionUpdates];
    //self.textBox.text = [NSString stringWithFormat:@"Accel stopped"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[self.textBox.text stringByAppendingString:@".csv"]];
    
    
    NSData* settingsData;
    settingsData = [accelView.csvOutput dataUsingEncoding: NSASCIIStringEncoding];
    
    if ([settingsData writeToFile:filePath atomically:YES])
        NSLog(@"writeok");
}

- (void)writeInertialDataToCSV
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (  textField ==  self.textBox ) {
    	NSTimeInterval animationDuration = 0.300000011920929;
    	CGRect frame = self.view.frame;
    	frame.origin.y -= 100;
    	frame.size.height += 100;
    	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    	[UIView setAnimationDuration:animationDuration];
    	self.view.frame = frame;
    	[UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( textField == self.textBox ) {
    	NSTimeInterval animationDuration = 0.300000011920929;
    	CGRect frame = self.view.frame;
    	frame.origin.y += 100;
    	frame.size.height -= 100;
    	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    	[UIView setAnimationDuration:animationDuration];
    	self.view.frame = frame;
    	[UIView commitAnimations];
    }
    // Additional Code
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
