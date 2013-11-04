//
//  E20SensorInfo.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//


#import "E20SensorInfo.h"
#include <math.h>


#define _USE_MATH_DEFINES


@implementation E20SensorInfo
@synthesize  gyroRaw;
@synthesize  gyroFiltered;
@synthesize  gravRaw;
@synthesize  gravFiltered;
@synthesize  accelRaw;
@synthesize  accelFiltered;


-(id) init
{
    self = [super init];
    if(self){
        gyroRaw = [[NSMutableArray alloc] init];
        gyroFiltered = [[NSMutableArray alloc] init];
        gravRaw = [[NSMutableArray alloc] init];
        gravFiltered = [[NSMutableArray alloc] init];
        accelRaw = [[NSMutableArray alloc] init];
        accelFiltered = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (void)setRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData
{
    /*sensorHistory is the input unfiltered signal
     filterParam includes:filterLength, firstFreqCutoff,secondFreqcutoff,samplingFreq
     rawData is any of the objects gyroRaw, gravRaw....
     filteredData is any of the objects gyroFiltered,...
    */
    int filterLength=[[filterParam objectAtIndex:0] intValue];
    double samplingFreq = [[filterParam objectAtIndex:3] doubleValue];
    double firstFreqCutoff = [[filterParam objectAtIndex:1] doubleValue];
    double secondFreqCutoff = [[filterParam objectAtIndex:2] doubleValue];
    double* weights=new double[filterLength];
    int M = filterLength-1;
    double ft1 = firstFreqCutoff/samplingFreq;
    double ft2 = secondFreqCutoff/samplingFreq;
    for (int i=0; i<filterLength; i++) {
        if(i!=M/2){
            weights[i]= sin(2*M_PI*ft2*(i-M/2))/(M_PI*(i-M/2))-sin(2*M_PI*ft1*(i-M/2))/(M_PI*(i-M/2));
        }
        else{
            weights[i] =  2*(ft2-ft1);
        }
        weights[i] = weights[i]*(0.54 - 0.46*cos(2*M_PI*i/M));
    }
    
    double outputSignal[3] = {0};
    for (int i=0; i<[sensorHistory count]; i++) {
        E203dDataPoint* dataPoint = [sensorHistory objectAtIndex:i];
        outputSignal[0] += dataPoint.x*weights[i];
        outputSignal[1] += dataPoint.y*weights[i];
        outputSignal[2] += dataPoint.z*weights[i];
        
    }
    E203dDataPoint* sourcePoint = [sensorHistory objectAtIndex:M];
    E203dDataPoint* rawPoint = [E203dDataPoint copyDataPoint:sourcePoint];
    [rawData addObject:rawPoint];
    E203dDataPoint* filteredPoint = [E203dDataPoint dataPointFromDouble:outputSignal];
    [filteredData addObject:filteredPoint];
    
    
                   
    
    
    
}

@end
