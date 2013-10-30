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

-(void)startMyMotionDetect
{
    
    __block float stepMoveFactor = 15;
    self.motionManager.accelerometerUpdateInterval = 1/100.0f;
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            CGRect rect = self.movingView.frame;
                            
                            float movetoX = rect.origin.x + (data.acceleration.x * stepMoveFactor);
                            float maxX = self.view.frame.size.width - rect.size.width;
                            
                            float movetoY = (rect.origin.y + rect.size.height)
                            - (data.acceleration.y * stepMoveFactor);
                            
                            float maxY = self.view.frame.size.height;
                            
                            if ( movetoX > 0 && movetoX < maxX ) {
                                rect.origin.x += (data.acceleration.x * stepMoveFactor);
                            };
                            
                            if ( movetoY > 0 && movetoY < maxY ) {
                                rect.origin.y -= (data.acceleration.y * stepMoveFactor);
                            };
                            
                            [UIView animateWithDuration:0 delay:0
                                                options:UIViewAnimationCurveEaseInOut
                                             animations:
                             ^{
                                 self.movingView.frame = rect;
                             }
                                             completion:nil
                             ];

                            
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
    
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager stopAccelerometerUpdates];
}
@end
