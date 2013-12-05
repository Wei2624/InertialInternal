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
        
        //write text
         CGContextSetRGBFillColor(contextRef, 1, 1, 0, 1.0);
        CGContextSelectFont(contextRef, "Helvetica-Light", 10.0f,kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(contextRef, kCGTextFill);
        CGAffineTransform trans = CGAffineTransformMakeScale(1, -1);
        CGContextSetTextMatrix(contextRef, trans);
        CGContextShowTextAtPoint(contextRef, 140, 175, "Blacks", strlen("Blacks"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 30, 250, "Shoppers Drug Mart", strlen("Shoppers Drug Mart"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 13.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 30, 410, "T-Booth Wireless", strlen("T-Booth Wireless"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 13.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 30, 450, "SoftMoc", strlen("SoftMoc"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 30, 500, "Toys Toys Toys", strlen("Toys Toys Toys"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 50, 560, "Colcutta", strlen("Colcutta"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 115, 600, "Nature", strlen("Nature"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 115, 660, "Telus", strlen("Telus"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 110, 720, "Calendar", strlen("Calendar"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 115, 790, "Fido", strlen("Fido"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 800, "American Eagle", strlen("American Eagle"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 690, "HMV", strlen("HMV"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 600, "Children's Place", strlen("Children's Place"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 500, "Aerie", strlen("Aerie"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 415, "Rogers", strlen("Rogers"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 360, "Sona", strlen("Sona"));
        CGContextSelectFont(contextRef, "Helvetica-Light", 15.0f,kCGEncodingMacRoman);
        CGContextShowTextAtPoint(contextRef, 400, 240, "Rich Tree", strlen("Rich Tree"));

        
        
    }

}


@end
