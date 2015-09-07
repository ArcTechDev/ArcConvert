//
//  ConverterViewController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ConverterViewController.h"
#import "Helper.h"
#import "Reachability.h"

@interface ConverterViewController ()

@property (strong, nonatomic) FPPopoverController *popController;
@property (weak, nonatomic) IBOutlet UIImageView *topIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downIndicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *topInputLabel;
@property (weak, nonatomic) IBOutlet UILabel *downInputLabel;
@property (weak, nonatomic) IBOutlet UILabel *topUnitDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *downUnitDisplayLabel;

@end

@implementation ConverterViewController{
    
    //current user input put unit top or down
    enum WorkingUnit currentWorkingUnit;
    
    //current user select unit top or down
    enum SelectUnit currentSelectUnit;
    
    //determine popController is hidden or not
    BOOL popControllerHidden;
    
    //current user input display label
    UILabel *currentWorkingInputLabel;
    
    //this converter's conversion type reference to ConverterManager
    NSUInteger convertType;
    
    //hold current converter all support unit in string
    NSArray *currentConvertableUnits;
    
    //hold select unit name for top
    NSString *topSelectedUnitName;
    
    //hold select unit name for down
    NSString *downSelectedUnitName;
    
    //user input for top
    NSString *topUserInput;
    
    //user input for down
    NSString *downUserInput;
    
    //store result after conversion
    NSNumber *result;
    
    BOOL drawDecimal;
}

@synthesize popController = _popController;
@synthesize topIndicatorImageView = _topIndicatorImageView;
@synthesize downIndicatorImageView = _downIndicatorImageView;
@synthesize topInputLabel = _topInputLabel;
@synthesize downInputLabel = _downInputLabel;
@synthesize topUnitDisplayLabel = _topUnitDisplayLabel;
@synthesize downUnitDisplayLabel = _downUnitDisplayLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    
    self.showNavigationBar = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self showCurrencyNote];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSArray *allUnits = [[ConverterManager sharedConverterManager] getAllConvertableUnitsWithConvertType:convertType];
    
    _topUnitDisplayLabel.text = [allUnits objectAtIndex:0];
    _downUnitDisplayLabel.text = [allUnits objectAtIndex:0];
    
    topSelectedUnitName = [allUnits objectAtIndex:0];
    downSelectedUnitName = [allUnits objectAtIndex:0];
    
    currentConvertableUnits = [allUnits copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public interface
- (void)setConversionType:(NSUInteger)cType{
    
    convertType = cType;
}

#pragma mark - internal
- (void)setup{
    
    if(currentWorkingUnit == TopUnit){
        
        [self switchWorkingUnit:TopUnit];
    }
    else{
        
        [self switchWorkingUnit:DownUnit];
    }
    
    currentSelectUnit = SelectUnknowUnit;
    
    //add tap gesture to top input label
    UITapGestureRecognizer *topInputLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topInputLabelTapped:)];
    [topInputLabelTap setNumberOfTouchesRequired:1];
    [_topInputLabel addGestureRecognizer:topInputLabelTap];
    
    //add tap gesture to down input label
    UITapGestureRecognizer *downInputLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downInputLabelTapped:)];
    [downInputLabelTap setNumberOfTouchesRequired:1];
    [_downInputLabel addGestureRecognizer:downInputLabelTap];
    
    topUserInput = @"0";
    downUserInput = @"0";
    
    drawDecimal = NO;
    popControllerHidden = YES;
    
}

- (void)showCurrencyNote{
    
    if(convertType == CCurrency){
        
        //currency converter notic
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Note" message:@"To insure currency converter working properly, please turn on internet connection" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alertView show];
    }
}

- (void)switchWorkingUnit:(NSUInteger)workingUnit{
    
    currentWorkingUnit = (enum WorkingUnit)workingUnit;
    
    if(workingUnit == TopUnit){
        
        _topIndicatorImageView.hidden = NO;
        _downIndicatorImageView.hidden = YES;
        currentWorkingInputLabel = _topInputLabel;
    }
    else{
        
        _topIndicatorImageView.hidden = YES;
        _downIndicatorImageView.hidden = NO;
        currentWorkingInputLabel = _downInputLabel;
    }
}

- (void)showUnitPickerFromView:(id)view withUnitStrings:(NSArray *)unitStrings{
    
    //create popController if needed
    if(_popController == nil){
        
        UnitPickViewController *unitPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitPickView"];
        
        ((DelegateViewController *)unitPicker).delegate = self;
        
        unitPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2.0f, self.view.frame.size.width);
        
        _popController = [[FPPopoverController alloc] initWithViewController:unitPicker];
        
        _popController.delegate = self;
        
        _popController.contentSize = CGSizeMake(unitPicker.view.frame.size.width, unitPicker.view.frame.size.height);
        
        unitPicker.unitToDisplay = unitStrings;
    }
    
    [_popController presentPopoverFromView:view];
    
}

- (void)handleDigitInpute:(NSString *)digit{
    
    
    if(currentWorkingUnit == TopUnit){
        
        if([self isMaxDigitalInputWithString:topUserInput]){
            return;
        }
        
        topUserInput = [topUserInput stringByAppendingString:digit];
    }
    else{
        
        if([self isMaxDigitalInputWithString:downUserInput]){
            return;
        }
        
       downUserInput = [downUserInput stringByAppendingString:digit];
    }
    
    
    [self doUnitConversion];
}

- (void)doUnitConversion{
    
    
    if(convertType == CCurrency){
        
        [self doCurrencyConversion];
    }
    else{
        
        DDUnit topUnit = [[ConverterManager sharedConverterManager] findUnitTypeByUnit:topSelectedUnitName WithConvertType:convertType];
        DDUnit downUnit = [[ConverterManager sharedConverterManager] findUnitTypeByUnit:downSelectedUnitName WithConvertType:convertType];
        
        if(currentWorkingUnit == TopUnit){
            
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:topUserInput];
            result = [[ConverterManager sharedConverterManager] convertWithValue:value WithType:convertType FromUnit:topUnit ToUnit:downUnit];
            
        }
        else{
            
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:downUserInput];
            result = [[ConverterManager sharedConverterManager] convertWithValue:value WithType:convertType FromUnit:downUnit ToUnit:topUnit];
            
        }
        
        [self updateDisplay];
    }
    
}

- (void)doCurrencyConversion{
    
    NSString *topCurrency = [[ConverterManager sharedConverterManager] findCurrencyByCurrency:topSelectedUnitName];
    NSString *downCurrency =[[ConverterManager sharedConverterManager] findCurrencyByCurrency:downSelectedUnitName];
    
    if(currentWorkingUnit == TopUnit){
        
        NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:topUserInput];
        
        [[ConverterManager sharedConverterManager] convertCurrencyWithValue:value WithCurrencyName:topCurrency ToCurrencyName:downCurrency OnComplete:^(BOOL success, NSDecimalNumber *convertResult){
        
            if(success){
                
                result = convertResult;
                
                [self updateDisplay];
            }
            else{
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus == NotReachable) {
                    
                    [self showCurrencyNote];
                }
            }
            
            
        }];
        
        
    }
    else{
        
        NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:downUserInput];
        
        [[ConverterManager sharedConverterManager] convertCurrencyWithValue:value WithCurrencyName:downCurrency ToCurrencyName:topCurrency OnComplete:^(BOOL success, NSDecimalNumber *convertResult){
            
            if(success){
                result = convertResult;
            
                [self updateDisplay];
            }
            else{
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus == NotReachable) {
                 
                    [self showCurrencyNote];
                }
            }
            
        }];
        
    }
}

- (void)updateDisplay{
    
    if(result == nil)
        return;
    
    if(currentWorkingUnit == TopUnit){
        
        NSString *str = [NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:topUserInput]];
        
        if(drawDecimal && ![Helper findCharacterInStringWithString:str WithCharacter:@"."]){
            
            str = [str stringByAppendingString:@"."];
            
            drawDecimal = NO;
        }
        
        _topInputLabel.text = str;
        
        
        NSString *resultStr = [Helper trimeStringWithString:[NSString stringWithFormat:@"%@", result] preserveCharacterCount:conversionMaxDigitalInput];
        
        _downInputLabel.text = resultStr;
        
        downUserInput = resultStr;
    }
    else{
        
        NSString *str = [NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:downUserInput]];
        
        if(drawDecimal && ![Helper findCharacterInStringWithString:str WithCharacter:@"."]){
            
            str = [str stringByAppendingString:@"."];
            
            drawDecimal = NO;
        }
        
        _downInputLabel.text = str;
        
        NSString *resultStr = [Helper trimeStringWithString:[NSString stringWithFormat:@"%@", result] preserveCharacterCount:conversionMaxDigitalInput];
        
        _topInputLabel.text = resultStr;
        
        topUserInput = resultStr;
    }
}

#pragma mark - utility
- (BOOL)isMaxDigitalInputWithString:(NSString *)string{
    
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:string];
    NSString *str = [num stringValue];
    
    NSUInteger characterCounts = str.length;
    
    if([Helper findCharacterInStringWithString:str WithCharacter:@"."]){
        
        characterCounts = characterCounts;
    }
    else if([Helper findCharacterInStringWithString:string WithCharacter:@"."]){
        
        characterCounts++;
    }
    
    if(characterCounts >= conversionMaxDigitalInput){
        
        return YES;
    }
    
    return NO;
    
}

#pragma mark - Gestures
- (void)topInputLabelTapped:(UITapGestureRecognizer *)gesture{
    
    [self switchWorkingUnit:TopUnit];
}

- (void)downInputLabelTapped:(UITapGestureRecognizer *)gesture{
    
    [self switchWorkingUnit:DownUnit];
}

#pragma mark - UnitPickViewConrtoller delegate
/**
 * Subclass override to receive unit pick view callback for unit select
 */
- (void)onUnitPickViewSelectUnitAtIndex:(NSUInteger)index withUnitName:(NSString *)UnitName{
    
    if(currentSelectUnit == SelectTopUnit){
        
        _topUnitDisplayLabel.text = [Helper getUnicodeStringFromString:[currentConvertableUnits objectAtIndex:index]];
        
        topSelectedUnitName = [currentConvertableUnits objectAtIndex:index];
    }
    else if(currentSelectUnit == SelectDownUnit){
        
        _downUnitDisplayLabel.text = [Helper getUnicodeStringFromString:[currentConvertableUnits objectAtIndex:index]];
        
        downSelectedUnitName = [currentConvertableUnits objectAtIndex:index];
    }
    else{
        
        NSLog(@"Cant change unit no unit select");
        return;
    }
    
    [_popController dismissPopoverAnimated:YES completion:nil];
    
    [self doUnitConversion];
}

#pragma mark - FPPopoverViewController delegate
/**
 * Subclass override
 */
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController shouldDismissVisiblePopover:(FPPopoverController *)visiblePopoverController{
    
    popControllerHidden = NO;
}

/**
 * Subclass override
 */
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController{
    
    popControllerHidden = YES;
}

#pragma mark - IBActions
- (IBAction)topUnitClick:(id)sender{
    
    currentSelectUnit = SelectTopUnit;
    
    //[self switchWorkingUnit:TopUnit];
    
    //[self showUnitPickerFromView:sender withUnitStrings:[NSArray arrayWithObjects:@"unit1",@"unit2",@"unit3",@"unit4",@"unit5", nil]];
    
    [self showUnitPickerFromView:sender withUnitStrings:currentConvertableUnits];
    
}

- (IBAction)downUnitClick:(id)sender{
    
    currentSelectUnit = SelectDownUnit;
    
    //[self switchWorkingUnit:DownUnit];
    
    //[self showUnitPickerFromView:sender withUnitStrings:[NSArray arrayWithObjects:@"unit1",@"unit2",@"unit3",@"unit4",@"unit5", nil]];
    
    [self showUnitPickerFromView:sender withUnitStrings:currentConvertableUnits];
}

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
    
    BOOL canHandleDecimal = YES;
    
    if(currentWorkingUnit == TopUnit){
        
        canHandleDecimal = ![Helper findCharacterInStringWithString:topUserInput WithCharacter:@"."];
    }
    else{
        
        canHandleDecimal = ![Helper findCharacterInStringWithString:downUserInput WithCharacter:@"."];
    }
    
    if(canHandleDecimal){
        
        drawDecimal = YES;
        [self handleDigitInpute:@"."];
    }
    
}

- (IBAction)clear:(id)sender{
    
    if(currentWorkingUnit == TopUnit){
        
        topUserInput = @"0";
    }
    else{
        
        downUserInput = @"0";
    }
    
    [self doUnitConversion];
}

- (IBAction)backwardDelete:(id)sender{
    
    if(currentWorkingUnit == TopUnit){
        
        if(topUserInput.length > 0){
            
            topUserInput = [topUserInput stringByReplacingCharactersInRange:NSMakeRange(topUserInput.length-1, 1) withString:@""];
            
        }
        
        if(topUserInput.length <=0){
            
            topUserInput = @"0";
        }
        else if([[topUserInput substringWithRange:NSMakeRange(topUserInput.length-1, 1)] isEqualToString:@"."]){
            
            drawDecimal = YES;
        }
    }
    else{
        
        if(downUserInput.length > 0){
            
            downUserInput = [downUserInput stringByReplacingCharactersInRange:NSMakeRange(downUserInput.length-1, 1) withString:@""];
            
        }
        
        if(downUserInput.length <=0){
            
            downUserInput = @"0";
        }
        else if([[downUserInput substringWithRange:NSMakeRange(downUserInput.length-1, 1)] isEqualToString:@"."]){
            
            drawDecimal = YES;
        }
    }
    
    [self doUnitConversion];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
