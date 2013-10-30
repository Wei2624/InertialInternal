//
//  E20AppDelegate.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface E20AppDelegate : UIResponder <UIApplicationDelegate>{

        CMMotionManager *motionManager;
    
}

@property (strong, nonatomic) UIWindow *window;

@end
