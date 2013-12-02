//
//  E20EatonTrackingMapView.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 12/1/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20EatonTrackingMapView.h"

@implementation E20EatonTrackingMapView
@synthesize canDraw;
@synthesize user1;
@synthesize user2;
@synthesize user3;
@synthesize user4;
@synthesize user5;
@synthesize eatonAreas;

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (canDraw == YES) {
        
        for(int i=0;i<[user1 count];i++){
            E20UserPosition* aUser = [user1 objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1.0);
            CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        }
        
        
        for(int i=0;i<[user2 count];i++){
            E20UserPosition* aUser = [user2 objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            CGContextSetRGBFillColor(contextRef, 1, 0, 0, 1.0);
            CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        }
        
        for(int i=0;i<[user3 count];i++){
            E20UserPosition* aUser = [user3 objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            CGContextSetRGBFillColor(contextRef, 0, 1, 1, 1.0);
            CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        }
        
        for(int i=0;i<[user4 count];i++){
            E20UserPosition* aUser = [user4 objectAtIndex:i];
            E20Matrix* positionVector = aUser.position.position;
            double radius = aUser.weight/(double)15;
            CGContextSetRGBFillColor(contextRef, 1, 0, 1, 1.0);
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


@end
