//
//  E20SensorInfo.h
//  InertialInternal
//
//  Created by E-Twenty Janahan on 11/3/13.
//  Copyright (c) 2013 E-Twenty Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E203dDataPoint.h"


#define numSensorHistoryStored 300

@interface E20SensorInfo : NSObject

@property (weak,nonatomic) NSMutableArray* gyroRaw;
@property (weak,nonatomic) NSMutableArray* gyroFiltered;
@property (weak,nonatomic) NSMutableArray* gravRaw;
@property (weak,nonatomic) NSMutableArray* gravFiltered;
@property (weak,nonatomic) NSMutableArray* accelRaw;
@property (weak,nonatomic) NSMutableArray* accelFiltered;

+ (void)setRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData;



@end
