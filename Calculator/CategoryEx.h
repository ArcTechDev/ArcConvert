//
//  NSNumberEx.h
//  Calculator
//
//  Created by User on 26/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSNumberEx)

+ (NSNumber *)decimalNumberFromString:(NSString *)string withMaxDecimal:(NSUInteger)count;
+ (NSString *)decimalStringFromNumber:(double)value withMaxDecimal:(NSUInteger)count;

@end
