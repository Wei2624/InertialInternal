//
//  E20Matrix.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/4/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import "E20Matrix.h"

@implementation E20Matrix

-(id) initWithRows: (int)rows andColumns: (int)columns{
    if( self = [super init]){
        _rows = rows;
        _columns = columns;
        _data = new double*[rows];
        
        for (int i=0; i<rows; i++) {
            _data[i] = new double[columns];
            for(int j=0; j<columns;j++){
                _data[i][j] = 0;
            }
        }
    }
    
    return self;
}

-(id) initWithRows: (int)rows andColumns: (int)columns withElementsInitializedTo:(double) elementValue{
    if( self = [super init]){
        _rows = rows;
        _columns = columns;
        _data = new double*[rows];
        
        for (int i=0; i<rows; i++) {
            _data[i] = new double[columns];
            for(int j=0; j<columns;j++){
                _data[i][j] = elementValue;
            }
        }
    }
    
    return self;
}

-(id) initWithRows: (int)rows andColumns: (int)columns andData:(double**) inputData{
    if( self = [super init]){
        _rows = rows;
        _columns = columns;
        _data = new double*[rows];
        
        for (int i=0; i<rows; i++) {
            _data[i] = new double[columns];
            for(int j=0; j<columns;j++){
                _data[i][j] = inputData[i][j];
            }
        }
    }
    
    return self;
}

-(id) initMatrixVectorWithRows: (int)rows andVectorData:(double *) inputData{
    if( self = [super init]){
        _rows = rows;
        _columns = 1;
        _data = new double*[rows];
        
        for (int i=0; i<rows; i++) {
            _data[i] = new double[1];
            for(int j=0; j<1;j++){
                _data[i][j] = inputData[i];
            }
        }
    }
    
    return self;

}



@end
