//
//  ConverterManager.h
//  Calculator
//
//  Created by User on 31/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDUnitConversion.h"

enum ConverterType{
    
    CLength = 0,
    CTemperature = 1,
    CSpeed = 2,
    CArea = 3,
    CVolume = 4,
    CWeight = 5,
    CTime = 6,
    CData = 7,
    CCurrency = 8
};

@interface ConverterManager : NSObject

+ (ConverterManager *)sharedConverterManager;
- (NSNumber *)convertWithValue:(NSDecimalNumber *)value WithType:(NSUInteger)type FromUnit:(DDUnit)from ToUnit:(DDUnit)to;
- (NSArray *)getAllConvertableUnitsWithConvertType:(NSUInteger)type;
- (NSUInteger)findUnitTypeByUnit:(NSString *)unitName WithConvertType:(NSUInteger)type;

@end
