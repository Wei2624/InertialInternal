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

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (canDraw == YES) {
        E20Matrix* positionVector = user1.position.position;
        double radius = user1.weight/(double)10;
        CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1.0);
        CGContextFillEllipseInRect(contextRef, CGRectMake(positionVector.data[0][0],positionVector.data[1][0],radius , radius));
        
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
