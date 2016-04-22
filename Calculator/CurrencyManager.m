//
//  CurrencyManager.m
//  Calculator
//
//  Created by User on 21/4/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import "CurrencyManager.h"
#import "Helper.h"

@implementation CurrencyManager{
    
    NSMutableDictionary *currencyData;
    NSDateFormatter *dateFormatter;
}

static CurrencyManager *_instance;

+ (CurrencyManager *)sharedManager{
    
    if(_instance == nil){
        
        _instance = [[CurrencyManager alloc] init];
    }
    
    return _instance;
}

- (BOOL)islocalDataVaild{
    
    if(currencyData == nil)
        return NO;
    
    return YES;
}

- (id)init{
    
    if(self = [super init]){
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        [self loadLocalData];
    }
    
    return self;
}

- (void)refreshCurrencyDataWith:(onRefreshCurrencySuccessful)successful fail:(onRefreshCurrencyFail)fail updateProgress:(onRefreshCurrencyProgressUpdate)progressUpdate{
    
    
    [[AFHTTPSessionManager manager] GET:CurrencyDataSource parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if(progressUpdate != nil){
            
            progressUpdate(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self parseCurrencyDataWithJsonData:responseObject];
        
        [self saveCurrencyData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            successful(self, currencyData[@"LastUpdate"]);
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(fail != nil){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                fail(error);
            });
            
            
        }
        
    }];
}

- (void)convertCurrencyWithValue:(NSDecimalNumber *)value fromCurrencyName:(NSString *)fromCurrencyName toCurrencyName:(NSString *)toCurrencyName successful:(onCurrencyConvertSuccessful)successful fail:(onCurrencyConvertFail)fail{
    
    if(currencyData == nil){
        
        fail([NSError errorWithDomain:@"Currency local data not vaild" code:Error_Local_Data_Not_Avaliable userInfo:nil]);
        
        return;
    }
    
    NSString *fromName = [fromCurrencyName uppercaseString];
    NSString *toName = [toCurrencyName uppercaseString];
    
    if([fromName isEqualToString:toName]){
        
        successful(value);
        
        return;
    }
    
    if([value compare:[NSNumber numberWithDouble:0.0]] == NSOrderedSame){
        
        successful(value);
        
        return;
    }
    
    if([fromName isEqualToString:@"USD"] || [toName isEqualToString:@"USD"]){
        
        //USD/(currency name)
        if([fromName isEqualToString:@"USD"]){
            
            NSDecimalNumber *price = [self getPriceWithName:toName];
            
            if(price != nil){
                
                successful([value decimalNumberByMultiplyingBy:price]);
                
                return;
            }
            
        }
        else{//(currency name)/USD
            
            NSDecimalNumber *price = [self getPriceWithName:fromName];
            
            if(price != nil){

                successful([value decimalNumberByDividingBy:price]);
                
                return;
            }
        }
    }
    else{//currency name/currency name
        
        NSDecimalNumber *price = [self getPriceWithName:fromName];
        
        if(price != nil){
            
            NSDecimalNumber *usd = [[NSDecimalNumber decimalNumberWithString:@"1"] decimalNumberByDividingBy:price];
            
            price = [self getPriceWithName:toName];
            
            if(price != nil){
                
                NSDecimalNumber *result = [[usd decimalNumberByMultiplyingBy:price] decimalNumberByMultiplyingBy:value];
                
                successful(result);
                
                return;
            }
        }
        
    }
    
    NSString *errString = [NSString stringWithFormat:@"No currency name were match in data for converting %@ to %@", fromCurrencyName, toCurrencyName];
    fail([NSError errorWithDomain:errString code:Error_Currency_Name_Not_Found userInfo:nil]);
}

- (UIAlertController *)alertControllerByErrorCode:(NSInteger)errorCode{
    
    if(errorCode == Error_Local_Data_Not_Avaliable){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There is no currency data in device, please turn on internet!" preferredStyle:UIAlertControllerStyleAlert];;
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        return alert;
    }
    else if(errorCode == Error_Currency_Name_Not_Found){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Converting error there is no match currency name!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        return alert;
    }
    
    return nil;
}

#pragma mark - Internal
//1 unit
- (NSDecimalNumber *)getPriceWithName:(NSString *)currencyName{

    NSDictionary *resource = currencyData[[NSString stringWithFormat:@"USD/%@", currencyName]];
    
    if(resource == nil)
        return nil;
    
    return [NSDecimalNumber decimalNumberWithString:resource[@"Price"]];
}

- (void)parseCurrencyDataWithJsonData:(id)cJsonData{
    
    currencyData = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary *resource in cJsonData[@"list"][@"resources"]){
        
        NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             resource[@"resource"][@"fields"][@"name"], @"CurrencyName",
                             resource[@"resource"][@"fields"][@"price"], @"Price"
                             
                              ,nil];
        
        [currencyData setValue:res forKey:resource[@"resource"][@"fields"][@"name"]];
    }
    
    NSString *updateString = [dateFormatter stringFromDate:[NSDate date]];
    [currencyData setValue:updateString forKey:@"LastUpdate"];
    
}

- (NSString *)getSavePath{
    
    NSString *docPath = [Helper getDocumentDirectoryPath];
    
    docPath = [docPath stringByAppendingPathComponent:LocalCurrencyFileName];
    
    return docPath;
}

- (BOOL)saveCurrencyData{
    
    if(currencyData != nil){
        
        BOOL successful = [currencyData writeToFile:[self getSavePath] atomically:YES];
        
        if(successful)
            return successful;
        else{
            
            NSLog(@"Save currency data fail");
            
            return !successful;
        }
    }
    
    NSLog(@"Currency data is nil, can not be saved");
    
    return NO;
}

- (void)loadLocalData{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:[self getSavePath]]){
        
        currencyData = [NSMutableDictionary dictionaryWithContentsOfFile:[self getSavePath]];
    }
}

@end
