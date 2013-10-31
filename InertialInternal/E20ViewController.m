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

@synthesize accelView;

-(void)startMyMotionDetect
{
    
    
    self.motionManager.accelerometerUpdateInterval = 1/10.0f;
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [accelView setCanDraw:YES];
                            int value = [accelView.positionY intValue];
                            //[myView setPositionY:[NSNumber numberWithInt:value + 10]];
                            accelView.positionY = [NSNumber numberWithInt:value+10];
                            [accelView setNeedsDisplay];
                            NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
                            NSLog(@"Time: %f", timeInMiliseconds);
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
    [accelView setPositionY:[NSNumber numberWithInt:100]];


    
    
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
    self.textBox.text = [NSString stringWithFormat:@"Accel started"];
    [self startMyMotionDetect];
//    [accelView setCanDraw:YES];
//    int value = [accelView.positionY intValue];
//    //[myView setPositionY:[NSNumber numberWithInt:value + 10]];
//    accelView.positionY = [NSNumber numberWithInt:value+10];
//    [accelView setNeedsDisplay];
    
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager stopAccelerometerUpdates];
    self.textBox.text = [NSString stringWithFormat:@"Accel stopped"];
}
@end
