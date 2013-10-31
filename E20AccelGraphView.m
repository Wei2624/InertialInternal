//
//  E20AccelGraphView.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 10/29/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20AccelGraphView.h"

@implementation E20AccelGraphView

@synthesize canDraw;


- (void)drawRect:(CGRect)rect {
    if (canDraw == YES) {
        
        // The color is by this line CGContextSetRGBFillColor( context , red , green , blue , alpha);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        // Draw a circle (filled)
        CGContextFillEllipseInRect(contextRef, CGRectMake(100, [self.positionY floatValue], 25, 25));
        CGContextSetRGBFillColor(contextRef, 0, 0, 255, 1.0);
        
        // Draw a circle (border only)
        CGContextStrokeEllipseInRect(contextRef, CGRectMake(100, 200, 25, 25));
        CGContextSetRGBFillColor(contextRef, 0, 0, 255, 1.0);

        
    }
}

@end
