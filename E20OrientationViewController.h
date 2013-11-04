//
//  E20OrientationViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20OrientationGraphView.h"

#define filterLength 101
@interface E20OrientationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet E20OrientationGraphView* orientationView;

@property (weak, nonatomic) IBOutlet E20SensorInfo* sensorInfoData;  //stores all the filtered and manipulated data

- (IBAction)startOrientation:(id)sender;

- (IBAction)stopOrientation:(id)sender;

- (IBAction)resetOrientation:(id)sender;

@end
