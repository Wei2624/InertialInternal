//
//  E20SickKidsViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/5/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E20SickKidsMapView.h"
#import "E20SickKidsScrollView.h"



@interface E20SickKidsViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet E20SickKidsMapView *skMapView;
@property (weak, nonatomic) IBOutlet E20SickKidsScrollView *scrollView;

@property (retain, nonatomic) E20SensorInfo* sensorInfoData;  //stores all the filtered and manipulated data
@property int iterationUpdatePosition;
-(void) loadData;
- (IBAction)startbutton:(id)sender;




@end
