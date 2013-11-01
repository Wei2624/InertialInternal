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
@synthesize gravHistory;
@synthesize accelHistory;
@synthesize gyroHistory;


- (void)drawRect:(CGRect)rect {
    if (canDraw == YES) {
        // The color is by this line CGContextSetRGBFillColor( context , red , green , blue , alpha);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        // Drawing lines with a white stroke color
        CGContextSetRGBStrokeColor(contextRef, 1.0, 0.0, 0.0, 1.0);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(contextRef, 2.0);

        for (int i=1; i<[gravHistory count]; i++) {
            // Draw a circle (filled)
            CMDeviceMotion *data = [gravHistory objectAtIndex:i];
            CMDeviceMotion *dataPrev = [gravHistory objectAtIndex:i-1] ;
            
            //X accel in red
            CGContextMoveToPoint(contextRef, i-1, 50-dataPrev.gravity.x*30);
            CGContextAddLineToPoint(contextRef, i, 50-data.gravity.x*30);
            CGContextStrokePath(contextRef);
        
            // Y accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 1.0, 0.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 50-dataPrev.gravity.y*30);
            CGContextAddLineToPoint(contextRef, i, 50-data.gravity.y*30);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);
            
            // Z accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 50-dataPrev.gravity.z*30);
            CGContextAddLineToPoint(contextRef, i, 50-data.gravity.z*30);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);

        }
        
        for (int i=1; i<[accelHistory count]; i++) {
            // Draw a circle (filled)
            CMAccelerometerData *data = [accelHistory objectAtIndex:i];
            CMAccelerometerData *dataPrev = [accelHistory objectAtIndex:i-1] ;
            
            //X accel in red
            CGContextMoveToPoint(contextRef, i-1, 150-dataPrev.acceleration.x*30);
            CGContextAddLineToPoint(contextRef, i, 150-data.acceleration.x*30);
            CGContextStrokePath(contextRef);
            
            // Y accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 1.0, 0.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 150-dataPrev.acceleration.y*30);
            CGContextAddLineToPoint(contextRef, i, 150-data.acceleration.y*30);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);
            
            // Z accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 150-dataPrev.acceleration.z*30);
            CGContextAddLineToPoint(contextRef, i, 150-data.acceleration.z*30);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);
            
        }
        
        for (int i=1; i<[gyroHistory count]; i++) {
            // Draw a circle (filled)
            CMGyroData *data = [gyroHistory objectAtIndex:i];
            CMGyroData *dataPrev = [gyroHistory objectAtIndex:i-1] ;

            //X accel in red
            CGContextMoveToPoint(contextRef, i-1, 250-dataPrev.rotationRate.x*5);
            CGContextAddLineToPoint(contextRef, i, 250-data.rotationRate.x*5);
            CGContextStrokePath(contextRef);
            
            // Y accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 1.0, 0.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 250-dataPrev.rotationRate.y*5);
            CGContextAddLineToPoint(contextRef, i, 250-data.rotationRate.y*5);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);
            
            // Z accel in green
            CGContextSaveGState(contextRef);
            CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 1.0);
            CGContextMoveToPoint(contextRef, i-1, 250-dataPrev.rotationRate.z*5);
            CGContextAddLineToPoint(contextRef, i, 250-data.rotationRate.z*5);
            CGContextStrokePath(contextRef);
            CGContextRestoreGState(contextRef);
            
        }
        
        
        

    }
}

@end
