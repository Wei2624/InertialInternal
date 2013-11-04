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

@property (retain,nonatomic) NSMutableArray* gyroRaw;
@property (retain,nonatomic) NSMutableArray* gyroFiltered;
@property (retain,nonatomic) NSMutableArray* gravRaw;
@property (retain,nonatomic) NSMutableArray* gravFiltered;
@property (retain,nonatomic) NSMutableArray* accelRaw;
@property (retain,nonatomic) NSMutableArray* accelFiltered;

+ (void)setRawAndFilteredValueWithInput:(NSMutableArray *) sensorHistory withFilterParam:(NSArray*) filterParam forRawData:(NSMutableArray *) rawData forFilteredData:(NSMutableArray *) filteredData;





@end
