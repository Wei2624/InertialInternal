//
//  E20SickKidsMapView.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/5/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20SickKidsMapView.h"

@implementation E20SickKidsMapView
@synthesize canDraw;
@synthesize skAreas;
@synthesize users;
- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (canDraw == YES) {
        
        
        
        for(int j=0;j<[skAreas count];j++){
            
                
                CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 1.0, 1.0);
                // Draw them with a 2.0 stroke width so they are a bit more visible.
                CGContextSetLineWidth(contextRef, 2.0);
            E20MapArea* area = [skAreas objectAtIndex:j];
            for(int i=0;i<4;i++){
                E20MapLine* currLine = [area.areaLines objectAtIndex:i];
                E202dMapPoint* startPoint = currLine.startPosition;
                E202dMapPoint* endPoint = currLine.endPosition;
                CGContextMoveToPoint(contextRef,startPoint.position.data[0][0], startPoint.position.data[1][0]                        );
                CGContextAddLineToPoint(contextRef, endPoint.position.data[0][0], endPoint.position.data[1][0]);
                CGContextStrokePath(contextRef);
            }
        }
        
        
        
    }

}

-(void) initUsersCenteredAtX:(double) x andY: (double) y andOrientationAngle: (double) angle{
    double xmin = x-20;
    double ymin = y-20;
    double angleMin = angle-25;
    double xrange = 40;
    double yrange = 40;
    double angleRange=50;
    for (int i=0; i<3; i++) {
        double xtemp = drand48()*xrange+xmin;
        double ytemp = drand48()*yrange+ymin;
        NSString* key = [NSString stringWithFormat:@" "];
        for(int j=0;j<3;j++){
            double angleTemp = drand48()*angleRange+angleMin;
            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:key];
            [users addObject:newUser];
        }
        for(int j=0;j<1;j++){
            double angleTemp = drand48()*360;
            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:[NSString stringWithFormat:@"area%d.csv",0]];
            newUser.weight = 30;
            [users addObject:newUser];
        }
    }
    
}

-(void) updateAllUsersOrientationOrientationVectorWithPlanarizedGyroPoint:(E201dDataPoint *) gyroPlanarizedPoint{
    for (int i=0; i<[users count]; i++) {
        E20UserPosition* aUser = [users objectAtIndex:i];
        [aUser updateOrientationVectorWithPlanarizedGyroPoint:gyroPlanarizedPoint];
    }
}

-(void) updatePositionForAllUsers{
    for (int i=0; i<[users count]; i++) {
        E20UserPosition* aUser = [users objectAtIndex:i];
        [aUser updatePositionForArea:eatonAreas];
        if(aUser.weight<5){
            [users removeObjectAtIndex:i];
        }
    }
    if([users count]<2){
        E20UserPosition* aUser = [users objectAtIndex:0];
        double x = aUser.position.position.data[0][0];
        double y = aUser.position.position.data[1][0];
        double angle = atan2(aUser.orientation.data[1][0], aUser.orientation.data[0][0]);
        angle = angle*180/M_PI;
        [self initUsersCenteredAtX:x andY:y andOrientationAngle:angle];
    }
    
    
}




@end
