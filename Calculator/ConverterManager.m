//
//  ConverterManager.m
//  Calculator
//
//  Created by User on 31/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ConverterManager.h"

@interface ConversionData : NSObject

@property (assign, nonatomic) NSNumber *value;
@property (assign, nonatomic) DDUnit fromUnit;
@property (assign, nonatomic) DDUnit toUnit;

@end

@implementation ConversionData

@synthesize value = _value;
@synthesize fromUnit = _fromUnit;
@synthesize toUnit = _toUnit;

@end

@implementation ConverterManager{
    
    NSMutableDictionary *conversionTools;
    NSMutableDictionary *converterTitles;
    ConversionData *reuseableData;
    NSDictionary *converterSettings;
    NSDecimalNumber *currencyValue;
    YFCurrencyConverter *currencyConverter;
    currencyConvertComplete currencyCallBack;
    NSString *tFromCurrency;
    NSString *tToCurrency;
}

static ConverterManager *instance;

#pragma mark - public interface
+ (ConverterManager *)sharedConverterManager{
    
    if(instance == nil){
        
        instance = [[ConverterManager alloc] init];
    }
    
    return instance;
}

- (NSString *)getTitleForConverterType:(enum ConverterType)type{
    
    if(converterTitles != nil){
        
        return [converterTitles objectForKey:[NSNumber numberWithUnsignedInteger:type]];
    }
    
    return nil;
}

- (NSNumber *)convertWithValue:(NSDecimalNumber *)value WithType:(NSUInteger)type FromUnit:(DDUnit)from ToUnit:(DDUnit)to{
    
    SEL sel = [[conversionTools objectForKey:[NSNumber numberWithUnsignedInteger:type]] pointerValue];
    
    if(sel != nil){
        
        if(reuseableData == nil){
            
            reuseableData = [[ConversionData alloc] init];
        }
        
        reuseableData.value = value;
        reuseableData.fromUnit = from;
        reuseableData.toUnit = to;
        
        return [self performSelector:sel withObject:reuseableData];
    }
    
    NSLog(@"ConverterManager cant find convert method");
    return nil;
}

- (NSArray *)getAllConvertableUnitsWithConvertType:(NSUInteger)type{
    
    if(converterSettings != nil){
        
        NSDictionary * unitsDic = [converterSettings objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)type]];
        
        return [unitsDic allKeys];
    }
    
    return nil;
}

- (NSUInteger)findUnitTypeByUnit:(NSString *)unitName WithConvertType:(NSUInteger)type{
    
    NSDictionary *unitsDic = [converterSettings objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)type]];
    
    return [[unitsDic objectForKey:unitName] unsignedIntegerValue];
}

- (NSString *)findCurrencyByCurrency:(NSString *)currencyName{
    
    NSDictionary *unitsDic = [converterSettings objectForKey:[NSString stringWithFormat:@"%d", CCurrency]];
    
    return [unitsDic objectForKey:currencyName];
}

- (void)convertCurrencyWithValue:(NSDecimalNumber *)value WithCurrencyName:(NSString *)fromCurrency ToCurrencyName:(NSString *)toCurrency OnComplete:(currencyConvertComplete)complete{
    
    currencyValue = value;
    currencyCallBack = complete;
    tFromCurrency = fromCurrency;
    tToCurrency = toCurrency;
    
    if(currencyConverter == nil){
        
        currencyConverter = [YFCurrencyConverter currencyConverterWithDelegate:self];
        currencyConverter.didFinishSelector = @selector(onCurrencyConvertSuccess:);
        currencyConverter.didFailSelector = @selector(onCurrencyConvertFail:);
    }
    
    [currencyConverter convertFromCurrency:fromCurrency toCurrency:toCurrency asynchronous:YES];
}

#pragma mark - YFCurrencyConversion delegate
- (void)onCurrencyConvertSuccess:(id)object{
    
    YFCurrencyConverter *result = object;
    
    NSLog(@"Currency convert from:%@ to:%@ conversion rate:%f",tFromCurrency, tToCurrency, result.conversionRate);
    
    if(result.error != nil){
        
        NSLog(@"Currency conversion error:%@", result.error);
        
        if(currencyCallBack != nil){
            
            currencyCallBack(NO, nil);
        }
        
        return;
    }
    
    NSDecimalNumber *convertResult = [currencyValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", result.conversionRate]]];
    
    if(currencyCallBack != nil){
        
        currencyCallBack(YES, convertResult);
    }
    
}

- (void)onCurrencyConvertFail:(id)object{
    
    YFCurrencyConverter *result = object;
    
    if(result.error != nil){
        
        NSLog(@"Currency conversion error:%@", result.error);
        
        if(currencyCallBack != nil){
            
            currencyCallBack(NO, nil);
        }
        
        return;
    }
}

#pragma mark - internal
- (id)init{
    
    if(self=[super init]){
        
        conversionTools = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           
                           [NSValue valueWithPointer:@selector(convertLengthWithData:)],
                           [NSNumber numberWithUnsignedInteger:CLength],
                           [NSValue valueWithPointer:@selector(convertTemperatureWithData:)],
                           [NSNumber numberWithUnsignedInteger:CTemperature],
                           [NSValue valueWithPointer:@selector(convertSpeedWithData:)],
                           [NSNumber numberWithUnsignedInteger:CSpeed],
                           [NSValue valueWithPointer:@selector(convertAreaWithData:)],
                           [NSNumber numberWithUnsignedInteger:CArea],
                           [NSValue valueWithPointer:@selector(convertVolumeWithData:)],
                           [NSNumber numberWithUnsignedInteger:CVolume],
                           [NSValue valueWithPointer:@selector(convertWeightWithData:)],
                           [NSNumber numberWithUnsignedInteger:CWeight],
                           [NSValue valueWithPointer:@selector(convertTimeWithData:)],
                           [NSNumber numberWithUnsignedInteger:CTime],
                           [NSValue valueWithPointer:@selector(convertDataWithData:)],
                           [NSNumber numberWithUnsignedInteger:CData]
                           //[NSValue valueWithPointer:@selector(convertCurrencyWithData:)],
                           //[NSNumber numberWithUnsignedInteger:CCurrency]
                           , nil];
        
        converterTitles = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           
                           @"Length",
                           [NSNumber numberWithUnsignedInteger:CLength],
                           @"Temperature",
                           [NSNumber numberWithUnsignedInteger:CTemperature],
                           @"Speed",
                           [NSNumber numberWithUnsignedInteger:CSpeed],
                           @"Area",
                           [NSNumber numberWithUnsignedInteger:CArea],
                           @"Volume",
                           [NSNumber numberWithUnsignedInteger:CVolume],
                           @"Weight",
                           [NSNumber numberWithUnsignedInteger:CWeight],
                           @"Time",
                           [NSNumber numberWithUnsignedInteger:CTime],
                           @"Data",
                           [NSNumber numberWithUnsignedInteger:CData],
                           @"Currency",
                           [NSNumber numberWithUnsignedInteger:CCurrency]
                           
                           , nil];
        
        [self loadSettingFile];
        
    }
    
    return self;
}

- (void)loadSettingFile{
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *pathForFile = [mainBundle pathForResource:@"UnitConversionSetting" ofType:@"plist"];
    
    converterSettings = [NSDictionary dictionaryWithContentsOfFile:pathForFile];
}

#pragma mark - Length converter
- (NSNumber *)convertLengthWithData:(ConversionData *)data{
    
    return [[DDUnitConverter lengthUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Temperature converter
- (NSNumber *)convertTemperatureWithData:(ConversionData *)data{
    
    return [[DDUnitConverter temperatureUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Speed converter
- (NSNumber *)convertSpeedWithData:(ConversionData *)data{
    
    return [[DDUnitConverter velocityUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Area converter
- (NSNumber *)convertAreaWithData:(ConversionData *)data{
    
    return [[DDUnitConverter areaUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Volume converter
- (NSNumber *)convertVolumeWithData:(ConversionData *)data{
    
    return [[DDUnitConverter volumeUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Weight converter
- (NSNumber *)convertWeightWithData:(ConversionData *)data{
    
    return [[DDUnitConverter massUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Time converter
- (NSNumber *)convertTimeWithData:(ConversionData *)data{
    
    return [[DDUnitConverter timeUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Data converter
- (NSNumber *)convertDataWithData:(ConversionData *)data{
    
    return [[DDUnitConverter byteUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

#pragma mark - Currency converter
/**
 * replaced by YFCurrencyConversion
 */
- (NSNumber *)convertCurrencyWithData:(ConversionData *)data{
    
    return [[DDUnitConverter currencyUnitConverter] convertNumber:data.value fromUnit:data.fromUnit toUnit:data.toUnit];
}

@end
