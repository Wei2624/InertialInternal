//
//  E20StepDetectionViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/16/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "E20SensorInfo.h"
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"
#import "E20Matrix.h"

@interface E20StepDetectionViewController : UIViewController

@property (nonatomic,strong) NSMutableArray* gravHistory;
@property (nonatomic,strong) NSMutableArray* accelHistory;
@property (nonatomic,strong) NSMutableArray* gyroHistory;

@property (retain, nonatomic) E20SensorInfo* sensorInfoData;  //stores all the filtered and manipulated data
@property int StepsTotal;
@property int StepsX;
@property int StepsY;
@property int StepsZ;

@property (weak, nonatomic) IBOutlet UITextField *TotalStepsText;
@property (weak, nonatomic) IBOutlet UITextField *ZStepsText;
@property (weak, nonatomic) IBOutlet UITextField *YStepsText;
@property (weak, nonatomic) IBOutlet UITextField *XStepsText;
- (IBAction)StartDectecting:(id)sender;
- (IBAction)StopDetecting:(id)sender;

@end
