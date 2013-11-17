//
//  E20SensorInfo.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E203dDataPoint.h"
#import "E201dDataPoint.h"



#define maxSensorHistoryStored 200

@interface E20SensorInfo : NSObject

@property (retain,nonatomic) NSMutableArray* gyroRaw;
@property (retain,nonatomic) NSMutableArray* gyroFiltered;
@property (retain,nonatomic) NSMutableArray* gyroPlanarizedRaw; //taking the gyro magnitude in the direction of gravity
@property (retain,nonatomic) NSMutableArray* gyroPlanarizedFiltered; 
@property (retain,nonatomic) NSMutableArray* gyroWhittaker;  //passing the gyroPlanarized through whittaker bias removal
@property (retain,nonatomic) NSMutableArray* gravRaw;
@property (retain,nonatomic) NSMutableArray* gravFiltered;
@property (retain,nonatomic) NSMutableArray* accelRaw;
@property (retain,nonatomic) NSMutableArray* accelFiltered;

+ (void)set3dRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData; //sycnhronizing raw and filtered values for 3d datapoints

+ (void)set1dRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData; //sycnhronizing raw and filtered values for 1d datapoints

+ (E201dDataPoint*)getGyroPlanarizedForGrav: (NSMutableArray *) gravHistory ForGyro: (NSMutableArray *) gyroHistory; //returns a 1dDataPoint
                //using the last gyro and gravity measurements


+(int) getPhoneOrientationWithRespectToGravity:(NSMutableArray*) gravHistory;

+(E201dDataPoint*) updateGyroWhittaker:(NSMutableArray*)gyroWhittaker WithParam: (NSArray*) whittakerParam forGyroPlanarizedRaw: (NSMutableArray*) gyroPlanarizedRaw forGyroPlanarizedFiltered: (NSMutableArray*) gyroPlanarizedFiltered;

+(bool) updateStepsDetectedUsingRawAccel: (NSMutableArray*) accelRaw filteredAccel: (NSMutableArray*) accelFiltered rawGyro:(NSMutableArray*) gyroRaw filteredGyro: (NSMutableArray*) gyroFiltered withKeyIndex: (int) keyIndex andStepParam:(NSArray*) stepParam;

+(void) updateCurrentStepData:(NSMutableArray*) currStepData withAccel: (NSMutableArray*) accelFiltered andGyro: (NSMutableArray*) gyroFiltered;

+(void) normalizeCurrentStepData: (NSMutableArray*) currStepData;

+(NSMutableArray*) magnitudeCurrentStepData: (NSMutableArray*) currStepData;

+(NSMutableArray*) avgCurrentStepData: (NSMutableArray*) currStepData;

+(NSMutableArray*) varianceCurrentStepData: (NSMutableArray*) currStepData withAvg: (NSMutableArray*) avg ;




@end
