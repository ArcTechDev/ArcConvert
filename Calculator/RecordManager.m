//
//  RecordManager.m
//  Calculator
//
//  Created by User on 20/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "RecordManager.h"
#import "Helper.h"

@implementation CalculationRecord{
    
    //calculation present in string
    NSString *representation;
    
    //digital set
    NSMutableArray *digitals;
    
    //operator set
    NSMutableArray *operators;
    
    //sum
    NSNumber *sum;
}

@synthesize calculateRepresentation = _calculateRepresentation;
@synthesize digitalSet = _digitalSet;
@synthesize operatorSet = _operatorSet;
@synthesize calculateSum = _calculateSum;

#pragma  mark - Getter
- (NSString *)getRepresentation{
    
    return representation;
}

- (NSArray *)getDigitals{
    
    return [NSArray arrayWithArray:digitals];
}

- (NSArray *)getOperators{
    
    return [NSArray arrayWithArray:operators];
}

- (NSNumber *)getSum{
    
    return sum;
}

#pragma mark - public interface
+ (CalculationRecord *)CreateEmptyRecord{
    
    return [[CalculationRecord alloc] init];
}

- (void)setCalculateRepresentation:(NSString *)calculateRepresentation{
    
    _calculateRepresentation = calculateRepresentation;
}

- (void)addDigital:(NSNumber *)digital{
    
    @synchronized(self){
        
        [digitals addObject:digital];
        
        //update representation
        [self updateRepresentation];
    }
    
}

- (void)addOperator:(NSString *)op{
    
    @synchronized(self){
        
        [operators addObject:op];
        
        //update representation
        [self updateRepresentation];
    }
    
}

- (void)replaceLastOperatorWithOperator:(NSString *)op{
    
    if(operators.count > 0){
        
        operators[operators.count-1] = op;
        
        [self updateRepresentation];
    }
}

- (void)removeLastOperator{
    
    if(operators.count > 0){
        
        [operators removeLastObject];
        
        [self updateRepresentation];
    }
}

- (void)setSum:(NSNumber *)sumValue{
    
    sum = sumValue;
}

- (BOOL)canSaveRecord{
    
    if([representation isEqualToString:@""] && sum == nil)
        return NO;
    
    return YES;
}

#pragma mark - internal
- (void)updateRepresentation{
    
    representation = @"";
    
    for(int i=0; i<digitals.count; i++){
        
        NSNumber *num = [digitals objectAtIndex:i];
        
        representation = [representation stringByAppendingString:[NSString stringWithFormat:@"%@", [NSNumber decimalStringFromNumber:[num doubleValue] withMaxDecimal:15]]];
        
        if(i<operators.count){
            
            NSString *op = [operators objectAtIndex:i];
            
            representation = [representation stringByAppendingString:op];
        }
    }
    
    NSLog(@"representation:%@", representation);
    NSLog(@"Raw data numbers:%@", digitals);
    NSLog(@"Raw data operators:%@", operators);
}

#pragma mark - override
- (id)init{
    
    if(self = [super init]){
        
        representation = @"";
        digitals = [[NSMutableArray alloc] init];
        operators = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end

@implementation RecordManager{
    
    CalculationRecord *currentRecord;
    NSMutableArray *records;
}

@synthesize delegate = _delegate;
@synthesize recordCount = _recordCount;

static RecordManager *instance;

#pragma mark - Getter
- (NSUInteger)getRecordCount{
    
    if(records != nil && records.count > 0)
        return records.count;
    
    return 0;
}

#pragma mark - public interface
+ (RecordManager *)sharedRecordManager{
    
    if(instance == nil){
        
        instance = [[RecordManager alloc] init];
    }
    
    return instance;
}

- (CalculationRecord *)currentRecord{
    
    return currentRecord;
}

- (void)createNewRecordSaveLast:(BOOL)yesOrNo{
    
    if(currentRecord != nil && yesOrNo == YES){
        
        [self saveCurrentRecord];
    }
    
    currentRecord = [CalculationRecord CreateEmptyRecord];
}

- (void)addDigital:(NSNumber *)digital{
    
    [currentRecord addDigital:digital];
    
    if([_delegate respondsToSelector:@selector(onRecordUpdate:)]){
        
        [_delegate onRecordUpdate:currentRecord];
    }
}

- (void)addOperator:(NSString *)op{
    
    [currentRecord addOperator:op];
    
    if([_delegate respondsToSelector:@selector(onRecordUpdate:)]){
        
        [_delegate onRecordUpdate:currentRecord];
    }
}

- (void)setSum:(NSNumber *)sumValue{
    
    [currentRecord setSum:sumValue];
}

- (void)replaceLastOperatorWithOperator:(NSString *)op{
    
    [currentRecord replaceLastOperatorWithOperator:op];
    
    if([_delegate respondsToSelector:@selector(onRecordUpdate:)]){
        
        [_delegate onRecordUpdate:currentRecord];
    }
}

- (void)removeLastOperator{
    
    [currentRecord removeLastOperator];
    
    if([_delegate respondsToSelector:@selector(onRecordUpdate:)]){
        
        [_delegate onRecordUpdate:currentRecord];
    }
}

- (CalculationRecord *)getRecordByIndex:(NSUInteger)index{
    
    if(records != nil && records.count > 0){
        
        return [records objectAtIndex:index];
    }
    
    return nil;
}

- (void)clearAllRecords{
    
    if(records != nil){
        
        [records removeAllObjects];
        
        NSString *path = [Helper getDocumentDirectoryPath];
        path = [path stringByAppendingPathComponent:recordFileName];
        
        [records writeToFile:path atomically:NO];
    }
}

#pragma mark - override
- (id)init{
    
    if(self = [super init]){
        
        [self loadRecord];
        
        currentRecord = [CalculationRecord CreateEmptyRecord];
    }
    
    return self;
}

#pragma mark - internal
/**
 * And easy way to load record
 */
- (void)loadRecord{
    
    records = [[NSMutableArray alloc] init];
    
    NSString *path = [Helper getDocumentDirectoryPath];
    path = [path stringByAppendingPathComponent:recordFileName];
    
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    
    if(data == nil)
        return;
    
    for(int i=0; i<data.count; i++){
        
        CalculationRecord *record = [CalculationRecord CreateEmptyRecord];
        
        NSDictionary *dic = [data objectAtIndex:i];
       
        [record setCalculateRepresentation:[dic objectForKey:@"Representation"]];
        
       
        NSArray *operators = [dic objectForKey:@"Operator"];
        for(int o=0; o<operators.count; o++){
            
            [record addOperator:[operators objectAtIndex:o]];
        }
        
         NSArray *numbers = [dic objectForKey:@"Number"];
        for(int n=0; n<numbers.count; n++){
            
            [record addDigital:[numbers objectAtIndex:n]];
        }
        
        [record setSum:[dic objectForKey:@"Sum"]];
        
        [records addObject:record];
    }
}

/**
 * And easy way to save current record
 */
- (void)saveCurrentRecord{
    
    if([currentRecord canSaveRecord]){
        
        [records addObject:currentRecord];
    }
    
    [self saveRecords];
}

- (void)saveRecords{
    
    NSString *path = [Helper getDocumentDirectoryPath];
    path = [path stringByAppendingPathComponent:recordFileName];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<records.count; i++){
        
        CalculationRecord *record = [records objectAtIndex:i];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setValue:record.calculateRepresentation forKey:@"Representation"];
        [dic setValue:record.digitalSet forKey:@"Number"];
        [dic setValue:record.operatorSet forKey:@"Operator"];
        [dic setValue:record.getSum forKey:@"Sum"];
        
        [dataArray addObject:dic];
    }
    
    if(dataArray.count > 0){
        
        [dataArray writeToFile:path atomically:NO];
    }
}

@end
