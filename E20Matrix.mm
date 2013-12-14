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

-(id) initMatrix2x1VectorWithX: (double) x andY:(double) y{
    double data[2] = {x,y};
    return [self initMatrixVectorWithRows:2 andVectorData:data];
    
}

-(double) get2x2Det{
    double** matrixData = self.data;
    double det = matrixData[0][0]*matrixData[1][1]-matrixData[1][0]*matrixData[0][1];
    return det;
}

-(E20Matrix*) get2x2Inverse{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:2];
    newMatrix.rows=2;
    newMatrix.columns=2;
    double** newMatrixData = newMatrix.data;
    double** matrixData = self.data;
    double det = [self get2x2Det];
    newMatrixData[0][0] = matrixData[1][1]/det;
    newMatrixData[1][1] = matrixData[0][0]/det;
    newMatrixData[0][1] = -matrixData[0][1]/det;
    newMatrixData[1][0] = -matrixData[1][0]/det;
    return newMatrix;
}

-(E20Matrix*) multiply2x2MatrixWith2x2:(E20Matrix *)matrix2{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:2];
    newMatrix.rows=2;
    newMatrix.columns=2;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;
    double** matrix2Data = matrix2.data;
    newMatrixData[0][0] = matrix1Data[0][0]*matrix2Data[0][0]+matrix1Data[0][1]*matrix2Data[1][0];
    newMatrixData[0][1] = matrix1Data[0][0]*matrix2Data[0][1]+matrix1Data[0][1]*matrix2Data[1][1];
    newMatrixData[1][0] = matrix1Data[1][0]*matrix2Data[0][0]+matrix1Data[1][1]*matrix2Data[1][0];
    newMatrixData[1][1] = matrix1Data[1][0]*matrix2Data[0][1]+matrix1Data[1][1]*matrix2Data[1][1];
    return newMatrix;
}

-(E20Matrix*) multiply2x2MatrixWith2x1: (E20Matrix*) matrix2{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    newMatrix.rows=2;
    newMatrix.columns=1;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;
    double** matrix2Data = matrix2.data;
    newMatrixData[0][0] = matrix1Data[0][0]*matrix2Data[0][0]+matrix1Data[0][1]*matrix2Data[1][0];
    newMatrixData[1][0] = matrix1Data[1][0]*matrix2Data[0][0]+matrix1Data[1][1]*matrix2Data[1][0];

    return newMatrix;
}

-(E20Matrix*) multiply2x1MatrixWithScalar: (double) scalar{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    newMatrix.rows=2;
    newMatrix.columns=1;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;

    newMatrixData[0][0] = matrix1Data[0][0]*scalar;
    newMatrixData[1][0] = matrix1Data[1][0]*scalar;
    
    return newMatrix;
}


-(E20Matrix*) subtract2x1MatrixWith2x1: (E20Matrix*) matrix2{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    newMatrix.rows=2;
    newMatrix.columns=1;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;
    double** matrix2Data = matrix2.data;
    newMatrixData[0][0] = matrix1Data[0][0]-matrix2Data[0][0];
    newMatrixData[1][0] = matrix1Data[1][0]-matrix2Data[1][0];
    
    return newMatrix;

}

-(E20Matrix*) add2x1MatrixWith2x1: (E20Matrix*) matrix2{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:2 andColumns:1];
    newMatrix.rows=2;
    newMatrix.columns=1;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;
    double** matrix2Data = matrix2.data;
    newMatrixData[0][0] = matrix1Data[0][0]+matrix2Data[0][0];
    newMatrixData[1][0] = matrix1Data[1][0]+matrix2Data[1][0];
    
    return newMatrix;
    
}

-(double) get2x1VectorMagnitude{
    double** data = self.data;
    double mag = pow(pow(data[0][0],2)+pow(data[1][0],2),0.5);
    return mag;
}

-(double) get2x1VectorDotProductWith:(E20Matrix*) matrix2{
    double** data1 = self.data;
    double** data2 = matrix2.data;
    double dot = data1[0][0]*data2[0][0]+data1[1][0]*data2[1][0];
    return dot;
}

-(E20Matrix*) returnSelfCopy{
    E20Matrix* newMatrix = [[E20Matrix alloc] initWithRows:self.rows andColumns:self.columns];
    newMatrix.rows=self.rows;
    newMatrix.columns=self.columns;
    double** newMatrixData = newMatrix.data;
    double** matrix1Data = self.data;
    for(int i=0;i<self.rows;i++){
        for(int j=0;j<self.columns;j++){
            newMatrixData[i][j] = matrix1Data[i][j];
        }
    }
    return newMatrix;
}

-(double) get2x1AngleinDegrees{
    double x = self.data[0][0];
    double y = self.data[1][0];
    return atan2(y, x)*180/M_PI;
}


@end
