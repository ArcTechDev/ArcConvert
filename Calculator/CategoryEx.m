//
//  NSNumberEx.m
//  Calculator
//
//  Created by User on 26/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "CategoryEx.h"

@implementation NSNumber (NSNumberEx)
    
    static NSNumberFormatter *decimalNumberFormatter;


+ (NSNumber *)decimalNumberFromString:(NSString *)string withMaxDecimal:(NSUInteger)count{

    if(decimalNumberFormatter == nil){
        
        decimalNumberFormatter = [[NSNumberFormatter alloc] init];
    }
    
    [decimalNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [decimalNumberFormatter setMaximumFractionDigits:count];
    
    return [decimalNumberFormatter numberFromString:string];
}

+ (NSString *)decimalStringFromNumber:(double)value withMaxDecimal:(NSUInteger)count{
    
    if(decimalNumberFormatter == nil){
        
        decimalNumberFormatter = [[NSNumberFormatter alloc] init];
    }
    
    [decimalNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [decimalNumberFormatter setMaximumFractionDigits:count];
    
    return [decimalNumberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

@end
