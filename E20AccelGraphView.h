//
//  E20AccelGraphView.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface E20AccelGraphView : UIView{}
@property (nonatomic,assign) BOOL canDraw;
@property (nonatomic,strong) NSMutableArray* gravHistory;
@property (nonatomic,strong) NSMutableArray* accelHistory;
@property (nonatomic,strong) NSMutableArray* gyroHistory;


@end
