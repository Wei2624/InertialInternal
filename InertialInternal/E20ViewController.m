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
    
    

    self.motionManager.deviceMotionUpdateInterval = 1/100.0f;
    [self.motionManager
     startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMDeviceMotion *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [accelView setCanDraw:YES];
                            [accelView.gravHistory addObject:data];
                            if ([accelView.gravHistory count]>400)
                            {
                                [accelView.gravHistory removeObjectAtIndex:0];
                            }
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
    [accelView setGravHistory:[[NSMutableArray alloc] init]];
    
    
    
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
    [self.motionManager startDeviceMotionUpdates];
    self.textBox.text = [NSString stringWithFormat:@"Accel stopped"];
}
@end
