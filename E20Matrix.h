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



@end
