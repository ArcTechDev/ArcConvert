//
//  ViewController.m
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ViewController.h"

@interface OperateArg : NSObject

@property (assign, nonatomic) double argA;
@property (assign, nonatomic) double argB;

@end

@implementation OperateArg

@synthesize argA = _argA;
@synthesize argB = _argB;

- (id)init{
    
    if(self = [super init]){
        
        _argA = 0.0;
        _argB = 0.0;
    }
    
    return self;
}

@end

@interface ViewController ()

@end

@implementation ViewController{
    
    //Dicctionary contain operation symbols as key and math methods as value
    NSMutableDictionary *opDic;
    
    //Array that stack number of result
    NSMutableArray *numberStack;
    
    //Array that stack operation symbol
    NSMutableArray *operationStack;
    
    //Store calculate result
    double accumulator;
    
    //User entered digits
    NSString *userInput;
    
    OperateArg *oArg;
    
    BOOL drawDecimal;

}

@synthesize displayField = _displayField;


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    
    //register operation methods
    opDic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                            
                                                            [NSValue valueWithPointer:@selector(addValueAB:)],
                                                            [NSValue valueWithPointer:@selector(subValueAB:)],
                                                            [NSValue valueWithPointer:@selector(multiplyValueAB:)],
                                                            [NSValue valueWithPointer:@selector(dividValueAB:)],
                                                            nil]
               
                                                   forKeys:[NSArray arrayWithObjects:
                                                            
                                                            @"+",
                                                            @"-",
                                                            @"*",
                                                            @"/",
                                                            nil]];
    
    numberStack = [[NSMutableArray alloc] init];
    operationStack = [[NSMutableArray alloc] init];
    accumulator = 0.0;
    userInput = @"";
    drawDecimal = NO;
    
   return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //test
    SEL sel = [[opDic objectForKey:@"+"] pointerValue];
    if(sel != nil){
        NSLog(@"result:%f", [[self performSelector:sel withObject:[self getOperateArg:1.5 WithArgB:1]] doubleValue]);
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility

- (OperateArg *)getOperateArg:(double)valA WithArgB:(double)valB{
    
    if(oArg != nil){
        
        oArg.argA = valA;
        oArg.argB = valB;
        
      
    }
    else{
        
        oArg  = [[OperateArg alloc] init];
        oArg.argA = valA;
        oArg.argB = valB;
    }
    
    return oArg;
}

/**
 * Find character in specific string
 *
 * @Param stringToFind the string that will be searched
 * @Param character the string character to be matched in search string
 * Return true if character found otherwise false
 */
- (BOOL)findCharacterInStringWithString:(NSString *)stringToFind WithCharacter:(NSString *)character{
    
    if([stringToFind isEqualToString:@""] || [character isEqualToString:@""])
        return NO;
    
    if([stringToFind rangeOfString:character options:NSLiteralSearch].location == NSNotFound)
        return NO;
    else
        return YES;
}

#pragma mark - Calculator brain
- (void)handleDigitInpute:(NSString *)digit{
    
    userInput = [userInput stringByAppendingString:digit];
    
    accumulator = [userInput doubleValue];
    
    NSLog(@"User input:%@, accumulator:%lf",userInput, accumulator);
    
    [self updateDisplay];
}

- (void)doMath:(NSString *)operationSymbol{
    
    if(numberStack.count > 0 && operationStack.count > 0){
        
        [self doEquals];
    }
    
    [numberStack addObject:[NSNumber numberWithDouble:accumulator]];
    [operationStack addObject:operationSymbol];
    userInput = @"";
    [self updateDisplay];
    
}

- (void)doEquals{
    
    if([userInput isEqualToString:@""])
        return;
    
    //if number stack has item
    if(numberStack.count > 0){
    
        //get operation symbol
        NSString *op = [operationStack lastObject];
        
        //get method for operation symbol
        SEL sel = [[opDic objectForKey:op] pointerValue];
        
        //if method found
        if(sel != nil){
            
            //remove last operation symbol from operation stack
            [operationStack removeLastObject];
            
            //get last number val from number stack
            double valA = [[numberStack lastObject] doubleValue];
            
            //do calculation base on method we get and store result into accumulator
            accumulator = [[self performSelector:sel withObject:[self getOperateArg:valA WithArgB:accumulator]] doubleValue];
            
            //remove last item from number stack
            [numberStack removeLastObject];
            
            //if operation stack is no empty keep calculating
            if(operationStack.count > 0){
                
                [self doEquals];
            }
        }
        else{
            
            NSLog(@"Operation not found for %@", op);
            
            return;
        }
        
        userInput =@"";
        [self updateDisplay];
        
    }
}

- (void)updateDisplay{
    
    //convert to integer
    int intAcc = (int)accumulator;
    
    //check if it is integer
    if((accumulator - (double)intAcc) == 0){
        
        self.displayField.text = [NSString stringWithFormat:@"%d", intAcc];
    }
    else{
        
        self .displayField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:accumulator]];
    }
    
    if(drawDecimal == YES){
        
        //if no decimal found in displayField then draw it
        if([self findCharacterInStringWithString:self.displayField.text WithCharacter:@"."] == NO){
            
            self.displayField.text = [self.displayField.text stringByAppendingString:@"."];
        }
        
        drawDecimal = NO;
    }
    
}

#pragma mark - Basic math
- (id)addValueAB:(OperateArg *)arg{
    
    return [NSNumber numberWithDouble:(arg.argA + arg.argB)];
}

- (id)subValueAB:(OperateArg *)arg{
    
    return [NSNumber numberWithDouble:(arg.argA - arg.argB)];
}

- (id)multiplyValueAB:(OperateArg *)arg{
    
    return [NSNumber numberWithDouble:(arg.argA * arg.argB)];
}

- (id)dividValueAB:(OperateArg *)arg{
    
     return [NSNumber numberWithDouble:(arg.argA / arg.argB)];
}

#pragma mark - Button action
- (IBAction)digitPress1:(id)sender{
    
    [self handleDigitInpute:@"1"];
}

- (IBAction)digitPress2:(id)sender{
    
    [self handleDigitInpute:@"2"];
}

- (IBAction)digitPress3:(id)sende{
    
    [self handleDigitInpute:@"3"];
}

- (IBAction)digitPress4:(id)sender{
    
    [self handleDigitInpute:@"4"];
}

- (IBAction)digitPress5:(id)sender{
    
    [self handleDigitInpute:@"5"];
}

- (IBAction)digitPress6:(id)sender{
    
    [self handleDigitInpute:@"6"];
}

- (IBAction)digitPress7:(id)sender{
    
    [self handleDigitInpute:@"7"];
}

- (IBAction)digitPress8:(id)sender{
    
    [self handleDigitInpute:@"8"];
}

- (IBAction)digitPress9:(id)sender{
    
    [self handleDigitInpute:@"9"];
}

- (IBAction)digitPress0:(id)sender{
    
    [self handleDigitInpute:@"0"];
}

- (IBAction)decimalSign:(id)sender{
    
    if([self findCharacterInStringWithString:userInput WithCharacter:@"."] == NO){
        
        drawDecimal = YES;
        [self handleDigitInpute:@"."];
        
    }
}

- (IBAction)equalSign:(id)sender{
    
    [self doEquals];
}

- (IBAction)clear:(id)sender{
    
    accumulator = 0.0;
    userInput = @"";
    [numberStack removeAllObjects];
    [operationStack removeAllObjects];
    
    [self updateDisplay];
}

- (IBAction)addSign:(id)sender{
    
    [self doMath:@"+"];
}

- (IBAction)subSign:(id)sender{
    
    [self doMath:@"-"];
}

- (IBAction)mutiplySign:(id)sender{
    
    [self doMath:@"*"];
}

- (IBAction)divideSign:(id)sender{
    
    [self doMath:@"/"];
}

@end
