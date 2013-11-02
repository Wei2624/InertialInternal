//
//  E20ViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "E20AccelGraphView.h"


@interface E20ViewController : UIViewController{
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet E20AccelGraphView *accelView;

@property (weak, nonatomic) IBOutlet UITextField *textBox;

@property (retain, nonatomic) NSMutableArray *labelPosition; //holds the times/counts when each label was added

@property  (weak, nonatomic) NSNumber * count; //current sensor iterrupt iteration

extern const int numInertialValuesStored;
@property (weak, nonatomic) IBOutlet UIButton *addLabel;


- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;
- (IBAction)addLabel:(id)sender;

@end
