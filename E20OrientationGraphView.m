//
//  E20OrientationGraphView.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20OrientationGraphView.h"

@implementation E20OrientationGraphView

@synthesize canDraw;
@synthesize orientationVector;
@synthesize positionVector;
@synthesize positionHistory;

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (canDraw == YES) {
        positionVector.data[0][0] = positionVector.data[0][0] + orientationVector.data[0][0]/15.0;
        positionVector.data[1][0] = positionVector.data[1][0] + orientationVector.data[1][0]/15.0;
        CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1.0);
        CGContextFillEllipseInRect(contextRef, CGRectMake(500-positionVector.data[0][0],500-positionVector.data[1][0], 10, 10));
        double vector[2];
        vector[0] = positionVector.data[0][0];
        vector[1] = positionVector.data[1][0];
        E20Matrix *currPosition = [[E20Matrix alloc] initMatrixVectorWithRows:2 andVectorData:vector];
        [positionHistory addObject:currPosition];
        CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 0.0, 1.0);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(contextRef, 2.0);

        for (int i=1; i<[positionHistory count]; i++) {
            // Draw a circle (filled)
            E20Matrix *data = [positionHistory objectAtIndex:i];
            E20Matrix *dataPrev = [positionHistory objectAtIndex:i-1] ;

            //X accel in red
            CGContextMoveToPoint(contextRef,500- dataPrev.data[0][0], 500-dataPrev.data[1][0]);
            CGContextAddLineToPoint(contextRef, 500-data.data[0][0], 500-data.data[1][0]);
            CGContextStrokePath(contextRef);

        }


    }
    else{
        CGContextSetRGBFillColor(contextRef, 1, 0, 0, 1.0);
        CGContextFillEllipseInRect(contextRef, CGRectMake(150,150, 10, 10));

    }
    
//    if(canDraw ==YES){
//        // Drawing lines with a white stroke color
//        CGContextSetRGBStrokeColor(contextRef, 1.0, 0.0, 0.0, 1.0);
//        // Draw them with a 2.0 stroke width so they are a bit more visible.
//        CGContextSetLineWidth(contextRef, 2.0);
//        
//        for (int i=1; i<[_gyroWhitt count]; i++) {
//            // Draw a circle (filled)
//            E201dDataPoint *data = [_gyroWhitt objectAtIndex:i];
//            E201dDataPoint *dataPrev = [_gyroWhitt objectAtIndex:i-1] ;
//            
//            //X accel in red
//            CGContextMoveToPoint(contextRef, i-1, 50-dataPrev.value*3000);
//            CGContextAddLineToPoint(contextRef, i, 50-data.value*3000);
//            CGContextStrokePath(contextRef);
//
//        }
//        
//        // Drawing lines with a white stroke color
//        CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 1.0, 1.0);
//        // Draw them with a 2.0 stroke width so they are a bit more visible.
//        CGContextSetLineWidth(contextRef, 1.0);
//        CGContextMoveToPoint(contextRef, 0, 50);
//        CGContextAddLineToPoint(contextRef, 320, 50);
//        CGContextStrokePath(contextRef);
//    }
}



-(void) updateOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint{
    double theta = gyroPlanarizedPoint.value; //already multiplied when creating planarizedgyro
    if(abs(gyroPlanarizedPoint.value)>0.1){
        theta = theta;
    }
    double Rot[2][2];
    Rot[0][0] =Rot[1][1]= cos(theta);
    Rot[0][1] = -sin(theta);
    Rot[1][0] = sin(theta);
    double x = self.orientationVector.data[0][0];
    double y = self.orientationVector.data[1][0];
    double x1 = Rot[0][0]*x+Rot[0][1]*y;
    double y1 = Rot[1][0]*x+Rot[1][1]*y;
    self.orientationVector.data[0][0] = x1;
    self.orientationVector.data[1][0] = y1;
}
@end
