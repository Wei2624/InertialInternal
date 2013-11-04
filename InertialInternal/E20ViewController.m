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
    
    
    
    self.motionManager.deviceMotionUpdateInterval = 1/150.0f;
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
                            
                            static NSTimeInterval prevTime; //holds the timestamp of the last sensor interrupt
                            static dispatch_once_t once;
                            
                            dispatch_once(&once, ^{
                                prevTime = data.timestamp;
                                
                            });
                            NSTimeInterval currTime = data.timestamp;
                            NSTimeInterval deltaT = currTime-prevTime; //time elapsed since last sensor interrupt
                            NSLog(@"Time: %f", deltaT);
                            if([accelView.gravHistory count] > 0 && [accelView.accelHistory count] > 0 && [accelView.gyroHistory count] > 0)
                            {
                                CMDeviceMotion *lastGrav = [accelView.gravHistory objectAtIndex:[accelView.gravHistory count]-1];
                                CMAccelerometerData *lastAccel = [accelView.accelHistory objectAtIndex:[accelView.accelHistory count]-1];
                                CMGyroData *lastGyro = [accelView.gyroHistory objectAtIndex:[accelView.gyroHistory count]-1];
                                
                                [accelView.csvOutput appendFormat:@"\n%f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f,%1.2f",deltaT,lastGyro.rotationRate.x,lastGyro.rotationRate.y,lastGyro.rotationRate.z,lastGrav.gravity.x,lastGrav.gravity.y,lastGrav.gravity.z,lastAccel.acceleration.x,
                                 lastAccel.acceleration.y,lastAccel.acceleration.z];

                            }
                            prevTime = currTime;
                            int value = [self.count intValue];
                            self.count = [NSNumber numberWithInt:value+1];
                            
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

    self.motionManager.accelerometerUpdateInterval = 1/150.0f;
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
    self.textBox.delegate = self;
    
    
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
    accelView.csvOutput = [NSMutableString stringWithString:@"Time,GyroX,GyroY,GyroZ,GravX,GravY,GravZ,AccelX,AccelY,AccelZ"];
    [accelView setCanDraw:NO];
    [accelView setGravHistory:[[NSMutableArray alloc] init]];
    [accelView setGyroHistory:[[NSMutableArray alloc] init]];
    [accelView setAccelHistory:[[NSMutableArray alloc] init]];
    self.labelPosition = [[NSMutableArray alloc] init];
    self.count = [NSNumber numberWithInt:0];
    
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
    //self.textBox.text = [NSString stringWithFormat:@"Accel stopped"];
    if([self.labelPosition count] > 0){
        [accelView.csvOutput appendFormat:@"\nLabel Positions\n"];
        for (int i = 0; i<[_labelPosition count]; i++) {
            int pos = [[_labelPosition objectAtIndex:i] intValue];
            [accelView.csvOutput appendFormat:@"%d,",pos];
        }
         
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath= nil;
    if(self.textBox.text.length >0){
            filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[self.textBox.text stringByAppendingString:@".csv"]];
    }
    else{
        NSDate *myDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *myDateString = [dateFormatter stringFromDate:myDate];

        filePath = [documentsDirectoryPath  stringByAppendingPathComponent:[myDateString stringByAppendingString:@".csv"]];
    }
    
    
    
    NSData* settingsData;
    settingsData = [accelView.csvOutput dataUsingEncoding: NSASCIIStringEncoding];
    
    if ([settingsData writeToFile:filePath atomically:YES])
        NSLog(@"writeok");
}

- (IBAction)addLabel:(id)sender {
    [self.labelPosition addObject:self.count];
    NSString* buttonText = [NSString stringWithFormat:@"Add Label =%lu",(unsigned long)[self.labelPosition count]];
    [_addLabel setTitle:buttonText forState:UIControlStateNormal];
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
