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
        
        for(int i=0;i<[users count];i++){
            E20UserPosition* aUser = [users objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            if(aUser.rebreadthSpawned == YES)
                CGContextSetRGBFillColor(contextRef, 1, 0, 0, 1.0);
            else
                CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1.0);
            CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        }

        
        
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
            CGContextSetRGBFillColor(contextRef, 1, 0, 0, 1.0);
            CGContextSelectFont(contextRef, "Helvetica-Light", 10.0f,kCGEncodingMacRoman);
            CGContextSetTextDrawingMode(contextRef, kCGTextFill);
            CGAffineTransform trans = CGAffineTransformMakeScale(1, -1);
            CGContextSetTextMatrix(contextRef, trans);
            NSString *s = [NSString stringWithFormat:@"%d",j];
            const char *c = [s UTF8String];
            
            CGContextShowTextAtPoint(contextRef, area.centerPoint.position.data[0][0], area.centerPoint.position.data[1][0],c, strlen(c));

            
        }
        
        
        
    }

}

-(void) initUsersCenteredAtX:(double) x andY: (double) y andOrientationAngle: (double) angle{
  


    double xmin = x-10;
    double ymin = y-10;
    double angleMin = angle-25;
    double xrange = 20;
    double yrange = 20;
    double angleRange=50;
    for (int i=0; i<10; i++) {
        double xtemp = drand48()*xrange+xmin;
        double ytemp = drand48()*yrange+ymin;
        NSString* key = [NSString stringWithFormat:@" "];
        for(int j=0;j<9;j++){
            double angleTemp = drand48()*angleRange+angleMin;
            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:key];
            newUser.currArea = [E20MapInfo returnKeyFromUserPosition:newUser.position mapAreas:skAreas];
            if(newUser.currArea!=-1){
                [users addObject:newUser];
            }
            
        }
        for(int j=0;j<9;j++){
            double angleTemp = drand48()*360;
            E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:[NSString stringWithFormat:@"area%d.csv",0]];
            newUser.weight = 30;
            newUser.currArea = [E20MapInfo returnKeyFromUserPosition:newUser.position mapAreas:skAreas];
            if(newUser.currArea!=-1){
                [users addObject:newUser];
            }
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
        E20MapLine* closestLine = [aUser updatePositionForArea:skAreas];
        if(aUser.weight<5){
            [users removeObjectAtIndex:i];
            if([users count]<2){
                E20UserPosition* aUser = [users objectAtIndex:0];
                double x = aUser.position.position.data[0][0];
                double y = aUser.position.position.data[1][0];
                double angle = atan2(aUser.orientation.data[1][0], aUser.orientation.data[0][0]);
                angle = angle*180/M_PI;
                [self initUsersCenteredAtX:x andY:y andOrientationAngle:angle];
            }

        }
        else if(closestLine!=nil){
            if (aUser.rebreadthCounter <=0)
                [self addBreadthToBlockedUser:aUser AtLine:closestLine];
        }
    }
    
    
}

-(void)addBreadthToBlockedUser: (E20UserPosition*) user AtLine: (E20MapLine*) closestLine{
    E20Matrix* lineVec = closestLine.getLineVector;
    lineVec = [lineVec multiply2x1MatrixWithScalar:1/(double)lineVec.get2x1VectorMagnitude];
    double vecx = lineVec.data[0][0];
    double vecy = lineVec.data[1][0];
    double x = user.position.position.data[0][0];
    double y = user.position.position.data[1][0];
    double angle = user.orientation.get2x1AngleinDegrees;
    double angleMin = angle-25;
    double xrange = 40;
    double yrange = 40;
    double angleRange=50;
    user.rebreadthCounter = 20;
    for (int i=0; i<8; i++) {
        double xtemp = (drand48()-0.5)*xrange*lineVec.data[0][0]+x;
        double ytemp = (drand48()-0.5)*yrange*lineVec.data[1][0]+y;
        NSString* key = [NSString stringWithFormat:@" "];
        
        double angleTemp = drand48()*angleRange+angleMin;
        E20UserPosition* newUser = [[E20UserPosition alloc] initWithPositionX:xtemp positionY:ytemp withOrientationAngle:angleTemp currentArea:key];
        newUser.currArea = [E20MapInfo returnKeyFromUserPosition:newUser.position mapAreas:skAreas];
        if(newUser.currArea!=-1){
            newUser.weight=user.weight*20;
            if(newUser.weight>150){
                newUser.weight=150;
            }
            newUser.rebreadthCounter = 3;
            newUser.rebreadthSpawned=YES;
            [users addObject:newUser];
    
        }
    }
    

}


@end
