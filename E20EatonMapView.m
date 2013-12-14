//
//  E20EatonMapView.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/30/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20EatonMapView.h"


@implementation E20EatonMapView

@synthesize canDraw;
@synthesize eatonAreas;
@synthesize user1;
@synthesize users;
@synthesize csvOutput;

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (canDraw == YES) {
        
        for(int i=0;i<[users count];i++){
            E20UserPosition* aUser = [users objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1.0);
            CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        }
        
        for(int j=0;j<[eatonAreas count];j++){
            if(j==0){
                
                CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 1.0, 1.0);
                // Draw them with a 2.0 stroke width so they are a bit more visible.
                CGContextSetLineWidth(contextRef, 2.0);
            }
            else{
                
                CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 0, 1.0);
                // Draw them with a 2.0 stroke width so they are a bit more visible.
                CGContextSetLineWidth(contextRef, 0.5);
            }
            NSMutableArray* mapLines = [eatonAreas objectForKey:[NSString stringWithFormat:@"area%d.csv",j]];
            for(int i=0;i<[mapLines count];i++){
                E20MapLine* currLine = [mapLines objectAtIndex:i];
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
//    double xmin = x-20;
//    double ymin = y-20;
//    double angleMin = angle-25;
//    double xrange = 40;
//    double yrange = 40;
//    double angleRange=50;
//    for (int i=0; i<3; i++) {
//        double xtemp = drand48()*xrange+xmin;
//        double ytemp = drand48()*yrange+ymin;
//        int* key = [E20MapInfo returnKeyFromUserPositionX:xtemp PositionY:ytemp mapDictionay:eatonAreas];
//        for(int j=0;j<3;j++){
//            double angleTemp = drand48()*angleRange+angleMin;
//            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:key];
//            [users addObject:newUser];
//        }
//        for(int j=0;j<1;j++){
//            double angleTemp = drand48()*360;
//            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:[NSString stringWithFormat:@"area%d.csv",0]];
//            newUser.weight = 30;
//            [users addObject:newUser];
//        }
//    }
    
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

-(void) updateRecording{
    if([users count]>0){
        [csvOutput appendFormat:@"\n"];
    }
    for(int i=0;i<[users count];i++){
        E20UserPosition* aUser = [users objectAtIndex:i];
    
        [csvOutput appendFormat:@"%1.2f,%1.2f,%1.2f",aUser.position.position.data[0][0],aUser.position.position.data[1][0],aUser.weight];
        if(i!=[users count]-1){
            [csvOutput appendFormat:@","];
        }
        
    }
    
}


@end
