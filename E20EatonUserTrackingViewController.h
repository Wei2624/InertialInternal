//
//  E20EatonUserTrackingViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20EatonTrackingScrollView.h"
#import "E20EatonTrackingMapView.h"

@interface E20EatonUserTrackingViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet E20EatonTrackingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet E20EatonTrackingMapView *eatonMapView;
@property int iterator1;
@property int iterator2;
@property int iterator3;
@property int iterator4;
@property int iterator5;
-(void) loadData;
-(void) loadRecordedUserPosition;
-(void)startMotionTracking;
@end
