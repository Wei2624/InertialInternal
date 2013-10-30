//
//  E20ViewController.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface E20ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textBox;

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;

@end
