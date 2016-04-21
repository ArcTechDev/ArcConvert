//
//  CurrencyManager.h
//  Calculator
//
//  Created by User on 21/4/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define CurrencyDataSource @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
#define LocalCurrencyFileName @"localCurrency.data"
#define Error_Local_Data_Not_Avaliable -1
#define Error_Currency_Name_Not_Found -2

@class CurrencyManager;

typedef void (^onRefreshCurrencySuccessful)(CurrencyManager*, NSString*);
typedef void (^onRefreshCurrencyFail)(NSError*);
typedef void (^onRefreshCurrencyProgressUpdate)(NSProgress*);
typedef void (^onCurrencyConvertSuccessful)(NSDecimalNumber *);
typedef void (^onCurrencyConvertFail)(NSError *);

@interface CurrencyManager : NSObject

+ (CurrencyManager *)sharedManager;

- (BOOL)islocalDataVaild;

/**
 * Update local currency data through internet
 */
- (void)refreshCurrencyDataWith:(onRefreshCurrencySuccessful)successful fail:(onRefreshCurrencyFail)fail updateProgress:(onRefreshCurrencyProgressUpdate)progressUpdate;

- (void)convertCurrencyWithValue:(NSDecimalNumber *)value fromCurrencyName:(NSString *)fromCurrencyName toCurrencyName:(NSString *)toCurrencyName successful:(onCurrencyConvertSuccessful)successful fail:(onCurrencyConvertFail)fail;

- (UIAlertController *)alertControllerByErrorCode:(NSInteger)errorCode;
@end
