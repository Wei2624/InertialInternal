//
//  E20SensorInfo.m
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//


#import "E20SensorInfo.h"
#include <math.h>
#include <vector>


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
@synthesize accelKeySensorRaw;
@synthesize accelKeySensorFiltered;

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
        accelKeySensorRaw = [[NSMutableArray alloc] init];
        accelKeySensorFiltered = [[NSMutableArray alloc] init];
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
    E203dDataPoint* sourcePoint = [sensorHistory objectAtIndex:M/2];
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
    E201dDataPoint* sourcePoint = [sensorHistory objectAtIndex:M/2];
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
    double gyroPlanarized = [gyroPoint dotProductWith:axis]*gyroPoint.timeStamp;
    E201dDataPoint* gyroPlanarizedPoint = [E201dDataPoint dataPointFromDouble:gyroPlanarized];
    gyroPlanarizedPoint.timeStamp = gyroPoint.timeStamp;
    gyroPlanarizedPoint.phoneOrientation = [E20SensorInfo getPhoneOrientationWithRespectToGravity:gravHistory];
    return gyroPlanarizedPoint;

}

+ (E201dDataPoint*)getAccelPlanarizedForGrav: (NSMutableArray *) gravHistory ForAccel: (NSMutableArray *) accelHistory{
    E203dDataPoint* axis = [gravHistory objectAtIndex:[gravHistory count]-1];
    [axis normalizeDataPoint];
    [axis normalizeDataPoint];
    E203dDataPoint* accelPoint = [accelHistory objectAtIndex:[accelHistory count]-1];
    double projection = [accelPoint dotProductWith:axis];
    E203dDataPoint* accelPlanarized = [accelPoint addByDataPoint:[axis multiplyByScalar:-projection]];
    
    return [accelPlanarized convert3Dto1DByTakingMagnitude];

}

+(int) getPhoneOrientationWithRespectToGravity:(NSMutableArray*) gravHistory{
    /*explained in header file*/
    E203dDataPoint* dataPoint = [gravHistory objectAtIndex:[gravHistory count]-1];
    int orientation = [E203dDataPoint indexOfMaxAbsValueOfDataPoint:dataPoint];
    return orientation;
}

+(E201dDataPoint*) updateGyroWhittaker:(NSMutableArray*)gyroWhittaker WithParam: (NSArray*) whittakerParam forGyroPlanarizedRaw: (NSMutableArray*) gyroPlanarizedRaw forGyroPlanarizedFiltered: (NSMutableArray*) gyroPlanarizedFiltered{
    /*estimates bias noise of gyroPlanarized: reference matlab file is whittrecursive1.m
     gyroWhittaker is the array where corrected gyroPlanarized values are being stored
     whittakerParam are parameters customized based on phoneOrientation
     gyroPlanarizedRaw are the raw planar gyro values
     gyroPlanarizedFiltered are the filtered planar gyro values used by whittaker
     */
    
    static double zbefore = 0;
    static double zbavg[3] = {0};
    static double zbnum[3] = {0};
    static int spikeLag=0;
    int filterLength = [[whittakerParam objectAtIndex:0] intValue];
    double lambda1 = [[whittakerParam objectAtIndex:1] doubleValue];
    double lambda2 = 3000;
    int offset = [[whittakerParam objectAtIndex:2] intValue];
    double spikeThreshold = [[whittakerParam objectAtIndex:3] doubleValue];
    int spikeLagReset = [[whittakerParam objectAtIndex:4] intValue];
    double avgs =0;
    double z = 0; //baseline for current sensor values
    for(int i =1;i<filterLength;i++){
        //Looks at the average differences in the filtered signal, when average differences high indicates turning
        //avgs looks slightly into the future to see if there is any active/abnormal movement signalling turning
        E201dDataPoint* gyroPlanarizedFilteredPoint1 = [gyroPlanarizedFiltered objectAtIndex:(i-1+offset)];
        E201dDataPoint* gyroPlanarizedFilteredPoint2 = [gyroPlanarizedFiltered objectAtIndex:(i+offset)];
        avgs += gyroPlanarizedFilteredPoint2.value-gyroPlanarizedFilteredPoint1.value;
    }
    avgs = avgs/filterLength;
    E201dDataPoint* gyroWhittakerPoint = [[E201dDataPoint alloc] init];
    if(ABS(avgs)>spikeThreshold || spikeLag>0){
        E201dDataPoint* gyroPlanarizedPoint = [gyroPlanarizedRaw objectAtIndex:0];
        int orient = gyroPlanarizedPoint.phoneOrientation;
        z = zbavg[orient];
        //z = zbefore;

        gyroWhittakerPoint.value = gyroPlanarizedPoint.value-z;
        gyroWhittakerPoint.timeStamp = gyroPlanarizedPoint.timeStamp;
        gyroWhittakerPoint.phoneOrientation = gyroPlanarizedPoint.phoneOrientation;
        if(spikeLag<=0){
            spikeLag = spikeLagReset;
            zbnum[orient] = 0;
        }
        else{
            spikeLag--;
        }
    }
    else{
        E201dDataPoint* gyroPlanarizedPoint = [gyroPlanarizedRaw objectAtIndex:0];
        int orient = gyroPlanarizedPoint.phoneOrientation;
        z = (gyroPlanarizedPoint.value + lambda1*zbefore)/(1+lambda1);
        zbnum[orient] = zbnum[orient]+1;
        zbavg[orient] = (zbavg[orient]*(zbnum[orient]-1) + zbefore)/zbnum[orient];
        gyroWhittakerPoint.value = gyroPlanarizedPoint.value-z;
        gyroWhittakerPoint.timeStamp = gyroPlanarizedPoint.timeStamp;
        gyroWhittakerPoint.phoneOrientation = gyroPlanarizedPoint.phoneOrientation;
    }
    zbefore = z;
    [gyroWhittaker addObject:gyroWhittakerPoint];
    if([gyroWhittaker count] > maxSensorHistoryStored){
        [gyroWhittaker removeObjectAtIndex:0];
    }
    NSLog(@"spikeLag: %d",spikeLag);
    return [E201dDataPoint copyDataPoint:gyroWhittakerPoint];
}

+(bool) updateStepsDetectedUsingKeyAccelRaw: (NSMutableArray*) accelKeyInfoRaw keyAccelFiltered: (NSMutableArray*) accelKeyInfoFiltered rawAcceleration:(NSMutableArray*) accelRaw andStepParam:(NSArray*) stepParam{
        /*decides whether step was taken based on purely in plane acceleration information
         stepParam is formatted as such lagtime,max_min,max_max,mag_min,mag_max,var_min,var_max*/
    E201dDataPoint* keyInfoPoint2 = [accelKeyInfoFiltered objectAtIndex:2];
    E201dDataPoint* keyInfoPoint1 = [accelKeyInfoFiltered objectAtIndex:1];
    E201dDataPoint* keyInfoPoint0 = [accelKeyInfoFiltered objectAtIndex:0];
    double diffPrev = keyInfoPoint2.value - keyInfoPoint1.value;
    double diffCurr = keyInfoPoint1.value - keyInfoPoint0.value;
    int orient = [E20SensorInfo getPhoneOrientationWithRespectToGravity:accelRaw];
    static int derivBefore = copysign(1,diffPrev);
    static int signChange =0;
    static int lagTime = [[stepParam objectAtIndex:0] intValue];//get right value
    double max_min = [[stepParam objectAtIndex:1] doubleValue];
    double max_max = [[stepParam objectAtIndex:2] doubleValue];
    double mag_min = [[stepParam objectAtIndex:3] doubleValue];
    double mag_max = [[stepParam objectAtIndex:4] doubleValue];
    double var_min = [[stepParam objectAtIndex:5] doubleValue];
    double var_max = [[stepParam objectAtIndex:6] doubleValue];
    static NSMutableArray* currStepData = [[NSMutableArray alloc] init];

    int derivNow = copysign(1,diffCurr);
    if(derivNow!=derivBefore){
        signChange++;
    }
    else{
        lagTime--;
        [E20SensorInfo updateCurrentStepData:currStepData withKeySensor: accelKeyInfoFiltered];
    }
    derivBefore = derivNow;
    bool step=NO;
    if(signChange>=2){
        if(lagTime<1){
            double avgCurrentStepData = [E20SensorInfo avgCurrentStepData:currStepData];
            currStepData = [E20SensorInfo unbiasCurrentStepData:currStepData withAvg:avgCurrentStepData]; //removes dc offset
            double magCurrentStepData = [E20SensorInfo magnitudeCurrentStepData:currStepData];
            double varCurrentStepData = [E20SensorInfo varianceCurrentStepData:currStepData withAvg:0]; //unbiased avg is zero
            double maxCurrentStepData = [E20SensorInfo maxCurrentStepData:currStepData];

            if(maxCurrentStepData >=max_min && maxCurrentStepData <=max_max){
                    if(magCurrentStepData >=mag_min && magCurrentStepData <=mag_max){
                            if(varCurrentStepData >=var_min && varCurrentStepData <=var_max){
                                step=YES;
                            }
                    }
            }
            currStepData = [[NSMutableArray alloc] init];
            lagTime = [[stepParam objectAtIndex:0] intValue];//get right value
        }
        signChange=0;
    }
    return step;
}

+(void) updateCurrentStepData:(NSMutableArray*) currStepData withKeySensor: accelKeyInfoFiltered{
    /*loads currStepData with current filtered sensor readings, uses this to measure variance, magnitude, dot product of step*/
    NSNumber* newStepData = [NSNumber numberWithDouble:[[accelKeyInfoFiltered objectAtIndex:0] getValue]];
    [currStepData addObject:newStepData];
    
}

+(double) magnitudeCurrentStepData: (NSMutableArray*) currStepData{
    /*calculate magnitude of current step data*/
    double mag = 0;
    for (int i=0; i<[currStepData count]; i++) {
        double temp = [[currStepData objectAtIndex:i] doubleValue];
        mag+= pow(temp,2);

    }
    
    return pow(mag,0.5);
}
+(double) maxCurrentStepData: (NSMutableArray*) currStepData{
    double max = -INFINITY;
    for (int i=0; i<[currStepData count]; i++) {
        double temp = ABS([[currStepData objectAtIndex:i] doubleValue]);
        if (temp>max) {
            max = temp;
        }
    }
    return max;
}
+(double) avgCurrentStepData: (NSMutableArray*) currStepData{
    /*calculate average of current step data*/
    double avg = 0;
    for (int i=0; i<[currStepData count]; i++) {
        double temp = [[currStepData objectAtIndex:i] doubleValue];
        avg+= temp;
    }
    if([currStepData count]>0){
        avg = avg/(double)[currStepData count];
        return avg;
    }
    else{
        return 0;
    }
}

+(NSMutableArray*) unbiasCurrentStepData: (NSMutableArray*) currStepData withAvg: (double) avg{
    //removes dc offset of currstep data such that after avg will be zero
    NSMutableArray* newStepData = [[NSMutableArray alloc] init];
    for (int i=0; i<[currStepData count]; i++) {
        NSNumber* temp = [currStepData objectAtIndex:i];
        double tempValue = [temp doubleValue];
        tempValue = tempValue- avg;
        temp = [NSNumber numberWithDouble:tempValue];
        [newStepData addObject:temp];
    }
    return newStepData;
}

+(double) varianceCurrentStepData: (NSMutableArray*) currStepData withAvg: (double) avg ;{
    /*calculate variance of current step data*/
    double var = 0;
    for (int i=0; i<[currStepData count]; i++) {
        double temp = [[currStepData objectAtIndex:i] doubleValue];
        var+= pow(temp-avg,2);
    }
    
    if([currStepData count]>0){
        var = var/(double)[currStepData count];
        return var;
    }
    else{
        return 0;
    }
}


+(void) normalizeCurrentStepData: (NSMutableArray*) currStepData{
    /*normalize current step data such that all values for ax,ay,az,gx,gy,gz have sumsqr 1*/
    double mag[] = {0,0,0,0,0,0};
    for (int i=0; i<[currStepData count]; i++) {
        NSArray* nsArray = [currStepData objectAtIndex:i];
        for(int j=0;j<6;j++){
            mag[j]+= pow([[nsArray objectAtIndex:j] doubleValue],2);
        }
    }
    for (int i=0; i<[currStepData count]; i++) {
        NSArray* nsArray = [currStepData objectAtIndex:i];
        for(int j=0;j<6;j++){
            NSNumber* number = [nsArray objectAtIndex:j];
            double value = [number doubleValue]/pow(mag[j],0.5);
            number = [NSNumber numberWithDouble:value];
        }
    }
}

@end
