//
//  E20Matrix.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/4/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface E20Matrix : NSObject

@property double** data;
@property int rows;
@property int columns;

-(id) initWithRows: (int)rows andColumns: (int)columns; //initializes all values to zero
-(id) initWithRows: (int)rows andColumns: (int)columns withElementsInitializedTo:(double) elementValue; //initializes all values to constant

-(id) initWithRows: (int)rows andColumns: (int)columns andData:(double**) inputData; //initializes elements to elements of data

-(id) initMatrixVectorWithRows: (int)rows andVectorData:(double *) inputData; //initializes elements to elements of vector data

-(id) initMatrix2x1VectorWithX: (double) x andY:(double) y; //initializes elements to elements of vector data

-(double) get2x2Det;
-(E20Matrix*) get2x2Inverse;
-(E20Matrix*) multiply2x2MatrixWith2x2: (E20Matrix*) matrix2;
-(E20Matrix*) multiply2x2MatrixWith2x1: (E20Matrix*) matrix2;
-(E20Matrix*) multiply2x1MatrixWithScalar: (double) scalar;
-(E20Matrix*) subtract2x1MatrixWith2x1: (E20Matrix*) matrix2;
-(E20Matrix*) add2x1MatrixWith2x1: (E20Matrix*) matrix2;
-(double) get2x1VectorMagnitude;
-(double) get2x1VectorDotProductWith:(E20Matrix*) matrix2;
-(E20Matrix*) returnSelfCopy;
-(double) get2x1AngleinDegrees;
@end
