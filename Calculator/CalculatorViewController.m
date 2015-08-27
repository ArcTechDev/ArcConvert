//
//  ViewController.m
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "CalculatorViewController.h"
#import "LeftMenuViewController.h"
#import "MainMenuViewController.h"
#import "DelegateViewController.h"



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
    //LeftMenuViewController *leftMenuViewController;
    
    //Main menu
    //MainMenuViewController *mainMenuViewController;
    
    //to store the view controller that will be panned
    UIViewController *pendingViewController;
    
    //to store last translation on this view when panning
    CGPoint lastTranslation;
    
    //determine was panning left or right
    BOOL panLeft;
    
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
    
    ADBannerView *adView;
    
}

@synthesize displayField = _displayField;
//@synthesize maskView = _maskView;
@synthesize dispalyCalculation = _dispalyCalculation;
@synthesize adbannerView = _adbannerView;


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    
    //register operation methods, any support math operator should add here
    opDic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                            
                                                            [NSValue valueWithPointer:@selector(addValueAB:)],
                                                            [NSValue valueWithPointer:@selector(subValueAB:)],
                                                            [NSValue valueWithPointer:@selector(multiplyValueAB:)],
                                                            [NSValue valueWithPointer:@selector(dividValueAB:)],
                                                            [NSValue valueWithPointer:@selector(percentValueA:)],
                                                            nil]
               
                                                   forKeys:[NSArray arrayWithObjects:
                                                            
                                                            @"+",
                                                            @"-",
                                                            @"*",
                                                            @"/",
                                                            @"%",
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
    /*
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePanGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
     */
    
    //register right edge pan
    UIScreenEdgePanGestureRecognizer *rightEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgePanGesture:)];
    rightEdgeGesture.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:rightEdgeGesture];
   
    //setup mask view
    //[self setupMaskView];
    
    //init left menu view
    //[self initLeftMenuView];
    
    //init main menu view
    //[self initMainMenuView];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setupNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation button
- (void)setupNavigationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    UIImage *image = [[UIImage imageNamed:@"History.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSArray *items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(showHistory)], nil];
    
    self.navigationItem.rightBarButtonItems = items;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:64.0/255.0 green:204.0/255.0 blue:177.0/255.0 alpha:0]];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    [titleBarAttributes setValue:[UIFont fontWithName:@"Lato-Medium" size:21.0f] forKey:UITextAttributeFont];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"aaa123";
    
}

/*
#pragma mark - LeftMenuView
- (void)initLeftMenuView{
    
    leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuView"];
    [leftMenuViewController addToParentViewController:self];
    
    leftMenuViewController.delegate = self;
}

#pragma mark - MainMenuView
- (void)initMainMenuView{
    
    mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuView"];
    [mainMenuViewController addToParentViewController:self];
    
}
 */

/*
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
 */

#pragma mark - Gestures
/**
 * handle gesture when user pan from edge screen or pan left on mask view
 */
/*
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
 */

- (void)handleRightEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    //if pendingViewController no exist create one which if MainMenuViewController
    if(pendingViewController == nil){
        
        pendingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuView"];
    }
    
    //we add pendingViewController's view as subview for view transition purpose
    [self.view addSubview:pendingViewController.view];
    
    //get current translation on this view
    CGPoint translation = [gesture translationInView:self.view];
    
    //if last time was not panning left and translation is greater than 0 set pendingViewController's view to most right
    //since pan from right edge is started from negative value and value become positive when pan over start point so
    //it can be determine which pendingViewController's view reach most right or not
    if(!panLeft && translation.x >= 0.0){
     
        pendingViewController.view.center = CGPointMake(self.view.frame.size.width + pendingViewController.view.frame.size.width/2, pendingViewController.view.center.y);
        return;
    }
    
    //check if pan left or right
    if(panLeft && translation.x > lastTranslation.x)
        panLeft = NO;
    else if(!panLeft && translation.x < lastTranslation.x)
        panLeft = YES;
    
    //when start pan gesture
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        //set pendingViewController's view to most right
        pendingViewController.view.center = CGPointMake(self.view.frame.size.width + pendingViewController.view.frame.size.width/2, pendingViewController.view.center.y);
        
        //store last translation
        lastTranslation = translation;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged){//when pan gesture changed
        
        //calculate translation percent value  on view
        float percent = translation.x * 100.0 / self.view.frame.size.width / 100.0;
        
        //set pendingViewController's view to new position
        pendingViewController.view.frame = CGRectMake(self.view.frame.size.width - pendingViewController.view.frame.size.width * fabs(percent), pendingViewController.view.frame.origin.y, pendingViewController.view.frame.size.width, pendingViewController.view.frame.size.height);
        
        //store translation
        lastTranslation = translation;
    }
    else{//somehow user's pan gesture end
        
        //start animation
        [UIView animateWithDuration:0.2 animations:^{
        
            //if was pan left animate view to left
            if(panLeft){
                pendingViewController.view.frame = CGRectMake(0.0, pendingViewController.view.frame.origin.y, pendingViewController.view.frame.size.width, pendingViewController.view.frame.size.height);
            }
            else{//otherwise animate view to right
                
                pendingViewController.view.center = CGPointMake(self.view.frame.size.width + pendingViewController.view.frame.size.width/2, pendingViewController.view.center.y);
            }
        } completion:^(BOOL finished){
        
            if(finished){
                
                //remove pendingViewController's view from super view
                [pendingViewController.view removeFromSuperview];
                
                //if was pan left push controller to navigation controller
                if(panLeft){
                    [self.navigationController pushViewController:pendingViewController animated:NO];
                    
                    [(DelegateViewController *)pendingViewController onPushIntoNavigationController];
                }
                
                //clear pendingViewController
                pendingViewController = nil;
            }
        }];
    }
    
}

/**
 * handle gesture when user tap on mask view to let left menu slide out
 */
/*
- (void)handleTapToDismissLeftMenu:(UITapGestureRecognizer *)gesture{
    
    //start LeftMenuViewController slide out animation and hide mask view on complete
    [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
    
        //hide mask view
        [self.maskView setHidden:YES];
        
    }];
}
 */

#pragma mark - AdBannerViewDelegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    NSLog(@"%@", error);
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

- (NSNumber *)preciseDoubleNumberWithDouble:(double)value{
    
    NSString *str = [NSString stringWithFormat:@"%.15f", value];
    
    return [NSNumber decimalNumberFromString:str withMaxDecimal:10];
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
    lastInputNumber = [self preciseDoubleNumberWithDouble:accumulator];
    
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
    
    [numberStack addObject:[self preciseDoubleNumberWithDouble:accumulator]];
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
        
        self .displayField.text = [NSString stringWithFormat:@"%@", [NSNumber decimalStringFromNumber:accumulator withMaxDecimal:15]];
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
    
    return [self preciseDoubleNumberWithDouble:(arg.argA + arg.argB)];
}

- (id)subValueAB:(OperateArg *)arg{
    
    return [self preciseDoubleNumberWithDouble:(arg.argA - arg.argB)];
}

- (id)multiplyValueAB:(OperateArg *)arg{
    
    return [self preciseDoubleNumberWithDouble:(arg.argA * arg.argB)];
}

- (id)dividValueAB:(OperateArg *)arg{
    
     return [self preciseDoubleNumberWithDouble:(arg.argA / arg.argB)];
}

- (id)percentValueA:(OperateArg *)arg{
    
    return [self preciseDoubleNumberWithDouble:(arg.argA * 0.01)];
}

#pragma mark - LeftMenuViewController delegate
- (void)onMenuItemSelected:(MenuItem *)item{
    
    NSLog(@"Select item:%@", item.itemTitle);
   
    /*
   [leftMenuViewController slideOutWithDuration:kAnimationDuration OnComplete:^{
    
        //[self.maskView setHidden:YES];
        
        [self performSegueWithIdentifier:item.itemTitle sender:nil];
    }];
     */
}

#pragma mark - RecordMenuViewController delegate
- (void)onRecordSelectedWithIndex:(NSUInteger)index{
    
    CalculationRecord *selectedRecord = [[RecordManager sharedRecordManager] getRecordByIndex:index];
    
    if(selectedRecord != nil){
        
        [self clearCalculator];
        
        self.dispalyCalculation.text = selectedRecord.getRepresentation;
        self.displayField.text = [NSString stringWithFormat:@"%@", selectedRecord.getSum];
        
        accumulator = [selectedRecord.getSum doubleValue];
        
        //set accumulator as last input number so that
        //user can use this accumulator as value to keep calculating
        lastInputNumber = [self preciseDoubleNumberWithDouble:accumulator];
        
        //create new record and save last record
        [[RecordManager sharedRecordManager] createNewRecordSaveLast:YES];
    }
}

#pragma mark - internal
- (void)showHistory{
    
    DelegateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorHitstoryMenu"];
    
    viewController.delegate = self;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController onPushIntoNavigationController];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    DelegateViewController *viewController = [segue destinationViewController];
    
    viewController.delegate = self;
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
        [[RecordManager sharedRecordManager] addDigital:[self preciseDoubleNumberWithDouble:accumulator]];
    }
    
    [self doEquals];
    
    [[RecordManager sharedRecordManager] setSum:[self preciseDoubleNumberWithDouble:accumulator]];
    
    //set accumulator as last input number so that
    //user can use this accumulator as value to keep calculating
    lastInputNumber = [self preciseDoubleNumberWithDouble:accumulator];
    
    //create new record and save last record
    [[RecordManager sharedRecordManager] createNewRecordSaveLast:YES];
    
}

- (IBAction)clear:(id)sender{
    
    [self clearCalculator];
    [self updateDisplay];
}

- (IBAction)backwardDelete:(id)sender{
    
    //if last input was digital so we can delete
    if(lastInputType == Digital){
        
        //check if input length greater than 0
        if([userInput length] > 0){
            
            NSLog(@"Remove digital");
            NSLog(@"Before remove user input:%@, accumulator:%@",userInput,[self preciseDoubleNumberWithDouble:accumulator]);
            
            //find last character range
            NSRange lastCharacterRange= NSMakeRange([userInput length] - 1, 1);
            //replace last character with none
            userInput = [userInput stringByReplacingCharactersInRange:lastCharacterRange withString:@""];
            
            //if new input hs no character left
            if([userInput length] == 0){
                
                //set accumulator to 0
                accumulator = 0;
            }
            else{
                
                //update accumulator
                accumulator = [userInput doubleValue];
            }
            
            //set to last input number
            lastInputNumber = [self preciseDoubleNumberWithDouble:accumulator];
            
            NSLog(@"After remove user input:%@, accumulator:%@",userInput,[self preciseDoubleNumberWithDouble:accumulator]);
        }
        
        [self updateDisplay];
    }
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

- (IBAction)percentSign:(id)sender{
    
    NSLog(@"Percent press");
    NSLog(@"Number set:%@", numberStack);
    NSLog(@"Operator set:%@", operationStack);
    NSLog(@"userinput:%@", userInput);
    NSLog(@"accumulator:%lf", accumulator);
    
    //if last input was digital
    if(lastInputType == Digital){
        
        //temporary store accumulator
        double tempAccumulator = accumulator;
        
        //do equal
        [self doEquals];
        
        //get method for percent operation
        SEL sel = [[opDic objectForKey:@"%"] pointerValue];
        
        if(sel == nil)
            return;
        
        //do percent math
        accumulator = [[self performSelector:sel withObject:[self getOperateArg:accumulator WithArgB:0]] doubleValue];
       
        //store temporary accumulator to number stack
        [numberStack addObject:[self preciseDoubleNumberWithDouble:tempAccumulator]];
        
        //store in record
        [[RecordManager sharedRecordManager] addDigital:[self preciseDoubleNumberWithDouble:tempAccumulator]];
        
        //store percent operation
        [operationStack addObject:@"%"];
        
        //store in record
        [[RecordManager sharedRecordManager] addOperator:@"%"];
        
    }
    else{//last input was operator or other than digital
        
        //Remove last operator if last input is operator
        if(lastInputType != Unknow && lastInputType == Operator && operationStack.count > 0){
            
            //since accumulator store the correct calculation result we dont
            //need and number or operator in stack
            [numberStack removeAllObjects];
            [operationStack removeAllObjects];
            
            //replace operator in record
            [[RecordManager sharedRecordManager] removeLastOperator];
        }
        
        //get method for percent operation symbol
        SEL sel = [[opDic objectForKey:@"%"] pointerValue];
        
        if(sel == nil)
            return;
        
        //do percent math
        accumulator = [[self performSelector:sel withObject:[self getOperateArg:accumulator WithArgB:0]] doubleValue];
        
        //store percent operation
        [operationStack addObject:@"%"];
        
        //store in record
        [[RecordManager sharedRecordManager] addOperator:@"%"];
    }
    
    NSLog(@"accumulator:%lf",accumulator);
    
    userInput = @"";
    [numberStack removeAllObjects];
    [operationStack removeAllObjects];
    
    [self updateDisplay];
    
    [[RecordManager sharedRecordManager] setSum:[self preciseDoubleNumberWithDouble:accumulator]];
    
    //set accumulator as last input number so that
    //user can use this accumulator as value to keep calculating
    lastInputNumber = [self preciseDoubleNumberWithDouble:accumulator];
    
    //create new record and save last record
    [[RecordManager sharedRecordManager] createNewRecordSaveLast:YES];
    
}

- (IBAction)positiveAndNegativeSign:(id)sender{
    
    //since userinput might get clear after doMath or doEquals so we need to
    //put last calculate result back to userInput so it can properly display on screen and
    //will not cause value become 0
    userInput = [NSString stringWithFormat:@"%@", [self preciseDoubleNumberWithDouble:accumulator]];
    [self handleDigitInpute:@"-"];
}

@end
