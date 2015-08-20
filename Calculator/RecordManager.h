//
//  RecordManager.h
//  Calculator
//
//  Created by User on 20/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculationRecord : NSObject

@property (getter=getRepresentation, nonatomic) NSString *calculateRepresentation;
@property (getter=getDigitals, nonatomic) NSArray *digitalSet;
@property (getter=getOperators, nonatomic) NSArray *operatorSet;

/**
 * Create empty record
 */
+ (CalculationRecord *)CreateEmptyRecord;
- (void)setCalculateRepresentation:(NSString *)calculateRepresentation;
- (void)addDigital:(NSNumber *)digital;
- (void)addOperator:(NSString *)op;
- (void)replaceLastOperatorWithOperator:(NSString *)op;
- (BOOL)canSaveRecord;

@end

//Record save file name and format
static NSString *recordFileName = @"Record.plist";

@protocol RecordManagerDelegate <NSObject>

@optional
- (void)onRecordUpdate:(CalculationRecord *)record;

@end

@interface RecordManager : NSObject

@property(weak, nonatomic) id<RecordManagerDelegate> delegate;

/**
 * Get the instance of RecordManager
 */
+ (RecordManager *)sharedRecordManager;

/**
 * Get current record
 * Return CalculatorRecord as record data
 */
- (CalculationRecord *)currentRecord;

/**
 * Create new record
 *
 * @Param yesOrNo Yes to save last record NO to discare last record
 */
- (void)createNewRecordSaveLast:(BOOL)yesOrNo;

/**
 * Add digital number to record
 */
- (void)addDigital:(NSNumber *)digital;

/**
 * Add operator to record
 */
- (void)addOperator:(NSString *)op;

/**
 * Replace last operator with new one
 */
- (void)replaceLastOperatorWithOperator:(NSString *)op;

@end
