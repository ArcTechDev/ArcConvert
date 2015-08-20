//
//  ViewController.m
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "CalculatorViewController.h"
#import "LeftMenuViewController.h"


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

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController{
    
    //Dicctionary contain operation symbols as key and math methods as value
    NSMutableDictionary *opDic;
    
    //Array that stack number of result
    NSMutableArray *numberStack;
    
    //Array that stack operation symbol
    NSMutableArray *operationStack;
    
    //Store calculate result
    //Value can be accumulated
    double accumulator;
    
    //User entered digits
    NSString *userInput;
    
    //store data that will be used by mathatical calculation
    OperateArg *oArg;
    
    //determine it should draw decimal or not
    //when decimal sign press this need to be YES
    //so display can display decimal properly
    BOOL drawDecimal;
    
    //left side menu
    LeftMenuViewController *leftMenuViewController;
    
    //user last input type that could be digital or operator
    //this is used to determine if user press an operator follow by
    //an operator and need to replace last operator
    enum InputType lastInputType;
    
    /**this last input number keep track user input number
     * so it can be store into record, the purpose of this variable
     * is to associate with RecordManager
     *
     * This need to be set to result of calculation after user
     * press equal sign so user can use this value for next
     * calculation
     */
    NSNumber *lastInputNumber;
}

@synthesize displayField = _displayField;
@synthesize maskView = _maskView;
@synthesize dispalyCalculation = _dispalyCalculation;


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    
    //register operation methods, any support math operator should add here
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
    lastInputType = Unknow;
    lastInputNumber = nil;
    
    [RecordManager sharedRecordManager].delegate = self;
    
   return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //register left edge pan
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePanGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
   
    [self setupMaskView];
    
    //init left menu view
    [self initLeftMenuView];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LeftMenuView
- (void)initLeftMenuView{
    
    leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuView"];
    [leftMenuViewController addToParentViewController:self];
    
    leftMenuViewController.delegate = self;
}

#pragma mark - MaskView
- (void)setupMaskView{
    
    //hide mask view
    [self.maskView setHidden:YES];
    
    //register tap gesture to mask view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToDismissLeftMenu:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.maskView addGestureRecognizer:tapGesture];
    
    //register pan gesture to mask view
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePanGesture:)];
    [self.maskView addGestureRecognizer:panGesture];
}

#pragma mark - Gestures
/**
 * handle gesture when user pan from edge screen or pan left on mask view
 */
- (void)handleLeftEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    //if gesture is UIScreenEdgePanGestureRecognizer
    if([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
        
        //turn on mask view
        [self.maskView setHidden:NO];
        
        //get touch translation
        CGPoint translation = [gesture translationInView:gesture.view];
        
        //if gesture state is began set last translation as current touch translation
        if(gesture.state == UIGestureRecognizerStateBegan){
            
            leftMenuViewController.lastTouchTranslation = translation;
        }
        
        //if gesture state is changed move and update left menu view
        if(gesture.state == UIGestureRecognizerStateChanged){
            
            [leftMenuViewController moveMenuViewWithTranslation:translation];
        }
        else{// gesture fail or other thing happen e.g user finger left
            
            //if left menu view was moving right perform slide in animation
            //otherwise left perform slide out animation
            if(leftMenuViewController.getDirection == Right){
                
                [leftMenuViewController slideInWithDuration:kAnimationDuration OnComplete:^{
                    
                    [self.maskView setHidden:NO];
                }];
            }
            else if(leftMenuViewController.getDirection == Left){
                
                [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
                    
                    [self.maskView setHidden:YES];
                }];
            }
        }
    }
    //if gesture is UIPanGestureRecognizer
    //user pan left on mask view
    else if([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
        
        //get touch translation
        CGPoint translation = [gesture translationInView:gesture.view];
        
        //if gesture state is began set last translation as current touch translation
        if(gesture.state == UIGestureRecognizerStateBegan){
            
            leftMenuViewController.lastTouchTranslation = translation;
        }
        
        //if gesture state is changed move and update left menu view
        if(gesture.state == UIGestureRecognizerStateChanged){
            
            [leftMenuViewController moveMenuViewWithTranslation:translation];
        }
        else{// gesture fail or other thing happen e.g user finger left
            
            //if left menu view was moving left perform slide out animation
            if(leftMenuViewController.getDirection == Left){
                
                [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
                    
                    //hide mask view when animation finished
                    [self.maskView setHidden:YES];
                }];
            }
        }
    }
    
}

/**
 * handle gesture when user tap on mask view to let left menu slide out
 */
- (void)handleTapToDismissLeftMenu:(UITapGestureRecognizer *)gesture{
    
    //start LeftMenuViewController slide out animation and hide mask view on complete
    [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
    
        //hide mask view
        [self.maskView setHidden:YES];
        
    }];
}

#pragma mark - Utility

//get data that will be used by mathatical method
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

- (void)clearCalculator{
    
    accumulator = 0.0;
    userInput = @"";
    lastInputType = Unknow;
    lastInputNumber = nil;
    self.dispalyCalculation.text = @"";
    [numberStack removeAllObjects];
    [operationStack removeAllObjects];
    [[RecordManager sharedRecordManager] createNewRecordSaveLast:NO];
}

#pragma mark - Calculator brain
/**
 * Handle calcualtor digital input
 */
- (void)handleDigitInpute:(NSString *)digit{
    
    //check if digit value is negative sign
    if([digit isEqualToString:@"-"]){
        
        //if input value was negative turn it into positive
        if([userInput hasPrefix:@"-"]){
            
            userInput = [userInput stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        else{
            
            userInput = [@"-" stringByAppendingString:userInput];
        }
    }
    else{
        
        userInput = [userInput stringByAppendingString:digit];
    }
    
    lastInputType = Digital;
    
    accumulator = [userInput doubleValue];
    
    //store last input number
    lastInputNumber = [NSNumber numberWithDouble:accumulator];
    
    NSLog(@"User input:%@, accumulator:%lf",userInput, accumulator);
    
    [self updateDisplay];
}

/**
 * handle when user press any of math calculation operator
 */
- (void)doMath:(NSString *)operationSymbol{
    
    //Change operator if last input is operator and dont calculate
    if(lastInputType != Unknow && lastInputType == Operator && operationStack.count > 0){
        
        operationStack[operationStack.count-1] = operationSymbol;
        
        //replace operator in record
        [[RecordManager sharedRecordManager] replaceLastOperatorWithOperator:operationSymbol];
        
        return;
    }
    
    if(numberStack.count > 0 && operationStack.count > 0){
        
        [self doEquals];
    }
    
    if(accumulator == INFINITY)
        return;
    
    //if last input number is nil store last input number into record
    if(lastInputNumber != nil)
       [[RecordManager sharedRecordManager] addDigital:lastInputNumber];
    
    //store operator in to record
    [[RecordManager sharedRecordManager] addOperator:operationSymbol];
    
    [numberStack addObject:[NSNumber numberWithDouble:accumulator]];
    [operationStack addObject:operationSymbol];
    userInput = @"";
    lastInputNumber = nil;
    lastInputType = Operator;
   // [self updateDisplay];
    
}

/**
 * handle user press equal operatoer on calculator
 */
- (void)doEquals{
    
    /*
    if([userInput isEqualToString:@""])
        return;
     */
    
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
        
        if(accumulator == INFINITY)
            [self clearCalculator];
    }
}

- (void)updateDisplay{
    
    if(accumulator == INFINITY){
        
        self.displayField.text = @"Error";
        return;
    }
    
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

#pragma mark - RecordManagerDelegate
- (void)onRecordUpdate:(CalculationRecord *)record{
    
    _dispalyCalculation.text = [[RecordManager sharedRecordManager] currentRecord].calculateRepresentation;
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

#pragma mark - LeftMenuViewController delegate
- (void)onMenuItemSelected:(MenuItem *)item{
    
    NSLog(@"Select item:%@", item.itemTitle);
    
    [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
    
        [self.maskView setHidden:YES];
    }];
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
    
    //if last input number is not nil then store last input number to record
    if(lastInputNumber != nil){
        [[RecordManager sharedRecordManager] addDigital:lastInputNumber];
    }
    else{
        [[RecordManager sharedRecordManager] addDigital:[NSNumber numberWithDouble:accumulator]];
    }
    
    [self doEquals];
    
    //set accumulator as last input number so that
    //user can use this accumulator as value to keep calculating
    lastInputNumber = [NSNumber numberWithDouble:accumulator];
    
    //create new record and save last record
    [[RecordManager sharedRecordManager] createNewRecordSaveLast:YES];
    
}

- (IBAction)clear:(id)sender{
    
    [self clearCalculator];
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

- (IBAction)positiveAndNegativeSign:(id)sender{
    
    //since userinput might get clear after doMath or doEquals so we need to
    //put last calculate result back to userInput so it can properly display on screen and
    //will not cause value become 0
    userInput = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:accumulator]];
    [self handleDigitInpute:@"-"];
}

@end
