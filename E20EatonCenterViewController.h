//
//  E20EatonCenterViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20EatonScrollView.h"
#import "E20EatonMapView.h"


@interface E20EatonCenterViewController : UIViewController
@property (weak, nonatomic) IBOutlet E20EatonScrollView *scrollView;
@property (weak, nonatomic) IBOutlet E20EatonMapView *eatonMapView;
@property int iterationUpdatePosition;
@property bool recordUsersData;

@property (retain, nonatomic) E20SensorInfo* sensorInfoData;  //stores all the filtered and manipulated data

-(void) loadData;
- (IBAction)stopMotionTracking:(id)sender;

@end
