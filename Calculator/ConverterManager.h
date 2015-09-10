//
//  ConverterManager.h
//  Calculator
//
//  Created by User on 31/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDUnitConversion.h"
#import "YFCurrencyConversion.h"

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

typedef void (^currencyConvertComplete)(BOOL, NSDecimalNumber*);

@interface ConverterManager : NSObject

+ (ConverterManager *)sharedConverterManager;
- (NSString *)getTitleForConverterType:(enum ConverterType)type;
- (NSNumber *)convertWithValue:(NSDecimalNumber *)value WithType:(NSUInteger)type FromUnit:(DDUnit)from ToUnit:(DDUnit)to;
- (NSArray *)getAllConvertableUnitsWithConvertType:(NSUInteger)type;
- (NSUInteger)findUnitTypeByUnit:(NSString *)unitName WithConvertType:(NSUInteger)type;
- (NSString *)findCurrencyByCurrency:(NSString *)currencyName;
- (void)convertCurrencyWithValue:(NSDecimalNumber *)value WithCurrencyName:(NSString *)fromCurrency ToCurrencyName:(NSString *)toCurrency OnComplete:(currencyConvertComplete)complete;

@end
