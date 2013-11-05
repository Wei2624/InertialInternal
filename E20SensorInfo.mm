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
@synthesize gyroPlanarizedRaw;
@synthesize gyroPlanarizedFiltered;
@synthesize gyroWhittaker;


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
        gyroPlanarizedRaw = [[NSMutableArray alloc] init];
        gyroPlanarizedFiltered = [[NSMutableArray alloc] init];
        gyroWhittaker = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (void)set3dRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData
{
    /*sensorHistory is the input unfiltered signal should be of length filterLength
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
    if([rawData count]>maxSensorHistoryStored){
        [rawData removeObjectAtIndex:0];
    }
    E203dDataPoint* filteredPoint = [E203dDataPoint dataPointFromDouble:outputSignal];
    [filteredData addObject:filteredPoint];
    if([filteredData count]>maxSensorHistoryStored){
        [filteredData removeObjectAtIndex:0];
    }
    
}

+ (void)set1dRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData
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
    
    double outputSignal = 0;
    for (int i=0; i<[sensorHistory count]; i++) {
        E201dDataPoint* dataPoint = [sensorHistory objectAtIndex:i];
        outputSignal += dataPoint.value*weights[i];
    }
    E201dDataPoint* sourcePoint = [sensorHistory objectAtIndex:M];
    E201dDataPoint* rawPoint = [E201dDataPoint copyDataPoint:sourcePoint];
    [rawData addObject:rawPoint];
    if([rawData count]>maxSensorHistoryStored){
        [rawData removeObjectAtIndex:0];
    }
    E201dDataPoint* filteredPoint = [E201dDataPoint dataPointFromDouble:outputSignal];
    //careful not setting timeStamp for filteredData...could be useful later on
    [filteredData addObject:filteredPoint];
    if([filteredData count]>maxSensorHistoryStored){
        [filteredData removeObjectAtIndex:0];
    }
    
}

+ (E201dDataPoint*)getGyroPlanarizedForGrav: (NSMutableArray *) gravHistory ForGyro: (NSMutableArray *) gyroHistory{
    /*explained in header file*/
    E203dDataPoint* axis = [gravHistory objectAtIndex:[gravHistory count]-1];
    [axis normalizeDataPoint];
    E203dDataPoint* gyroPoint = [gyroHistory objectAtIndex:[gyroHistory count]-1];
    double gyroPlanarized = [gyroPoint dotProductWith:axis];
    E201dDataPoint* gyroPlanarizedPoint = [E201dDataPoint dataPointFromDouble:gyroPlanarized];
    gyroPlanarizedPoint.timeStamp = gyroPoint.timeStamp;
    gyroPlanarizedPoint.phoneOrientation = [E20SensorInfo getPhoneOrientationWithRespectToGravity:gravHistory];
    return gyroPlanarizedPoint;

}

+(int) getPhoneOrientationWithRespectToGravity:(NSMutableArray*) gravHistory{
    /*explained in header file*/
    E203dDataPoint* dataPoint = [gravHistory objectAtIndex:[gravHistory count]-1];
    int orientation = [E203dDataPoint indexOfMaxAbsValueOfDataPoint:dataPoint];
    return orientation;
}

+(void) updateGyroWhittaker:(NSMutableArray*)gyroWhittaker WithParam: (NSArray*) whittakerParam forGyroPlanarizedRaw: (NSMutableArray*) gyroPlanarizedRaw forGyroPlanarizedFiltered: (NSMutableArray*) gyroPlanarizedFiltered{
    /*estimates bias noise of gyroPlanarized: reference matlab file is whittrecursive1.m
     gyroWhittaker is the array where corrected gyroPlanarized values are being stored
     whittakerParam are parameters customized based on phoneOrientation
     gyroPlanarizedRaw are the raw planar gyro values
     gyroPlanarizedFiltered are the filtered planar gyro values used by whittaker
     */
    
    static double zbefore = 0;
    static double zbavg = 0;
    static double zbnum = 0;
    static int spikeLag=0;
    int filterLength = [[whittakerParam objectAtIndex:0] intValue];
    double lambda1 = [[whittakerParam objectAtIndex:1] doubleValue];
    double lambda2 = 3000;
    int offset = [[whittakerParam objectAtIndex:2] intValue];
    double spikeThreshold = [[whittakerParam objectAtIndex:3] doubleValue];
    int spikeLagReset = [[whittakerParam objectAtIndex:4] intValue];
    double* weights = new double[filterLength];
    weights[0] = weights[filterLength-1] = 1/24.0;
    for (int i =1; i<filterLength-1; i++) {
        weights[i] = 1/12.0;
    }
    double mav =0;
    double z = 0; //baseline for current sensor values
    for(int i =0;i<filterLength;i++){
        //dot product of filteredGyro and weights...should probably create dot product function for this later
        //mav looks slightly into the future to see if there is any active/abnormal movement signalling turning
        E201dDataPoint* gyroPlanarizedFilteredPoint = [gyroPlanarizedFiltered objectAtIndex:(i+offset)];
        mav += gyroPlanarizedFilteredPoint.value*weights[i];
    }
    E201dDataPoint* gyroWhittakerPoint = [[E201dDataPoint alloc] init];
    if(ABS(mav)>spikeThreshold || spikeLag>0){
        z = zbavg;
        E201dDataPoint* gyroPlanarizedPoint = [gyroPlanarizedRaw objectAtIndex:0];
        gyroWhittakerPoint.value = gyroPlanarizedPoint.value-z;
        gyroWhittakerPoint.timeStamp = gyroPlanarizedPoint.timeStamp;
        gyroWhittakerPoint.phoneOrientation = gyroPlanarizedPoint.phoneOrientation;
        if(spikeLag<=0){
            spikeLag = spikeLagReset;
            zbnum = 0;
        }
        else{
            spikeLag--;
        }
    }
    else{
        E201dDataPoint* gyroPlanarizedPoint = [gyroPlanarizedRaw objectAtIndex:0];
        z = (gyroPlanarizedPoint.value + lambda1*zbefore)/(1+lambda1);
        zbnum = zbnum+1;
        zbavg = (zbavg*(zbnum-1) + zbefore)/zbnum;
        gyroWhittakerPoint.value = gyroPlanarizedPoint.value-z;
        gyroWhittakerPoint.timeStamp = gyroPlanarizedPoint.timeStamp;
        gyroWhittakerPoint.phoneOrientation = gyroPlanarizedPoint.phoneOrientation;
    }
    [gyroWhittaker addObject:gyroWhittakerPoint];
    if([gyroWhittaker count] > maxSensorHistoryStored){
        [gyroWhittaker removeObjectAtIndex:0];
    }
    
}

@end
