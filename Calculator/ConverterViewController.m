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
#import "ConverterInputView.h"

@interface ConverterViewController ()

@property (strong, nonatomic) FPPopoverController *popController;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *separatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downIndicatorImageView;
@property (weak, nonatomic) IBOutlet ConverterInputView *topInputView;
@property (weak, nonatomic) IBOutlet ConverterInputView *downInputView;
@property (weak, nonatomic) IBOutlet UILabel *topInputLabel;
@property (weak, nonatomic) IBOutlet UILabel *downInputLabel;
@property (weak, nonatomic) IBOutlet UILabel *topUnitDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *downUnitDisplayLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIButton *btnBackward;
@property (weak, nonatomic) IBOutlet UIButton *btnDot;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;

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
    enum ConverterType convertType;
    
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
@synthesize bgImageView = _bgImageView;
@synthesize separatorImageView = _separatorImageView;
@synthesize topIndicatorImageView = _topIndicatorImageView;
@synthesize downIndicatorImageView = _downIndicatorImageView;
@synthesize topInputView = _topInputView;
@synthesize downInputView = _downInputView;
@synthesize topInputLabel = _topInputLabel;
@synthesize downInputLabel = _downInputLabel;
@synthesize topUnitDisplayLabel = _topUnitDisplayLabel;
@synthesize downUnitDisplayLabel = _downUnitDisplayLabel;
@synthesize btnClear = _btnClear;
@synthesize btnBackward = _btnBackward;
@synthesize btnDot = _btnDot;
@synthesize btn0 = _btn0;
@synthesize btn1 = _btn1;
@synthesize btn2 = _btn2;
@synthesize btn3 = _btn3;
@synthesize btn4 = _btn4;
@synthesize btn5 = _btn5;
@synthesize  btn6 = _btn6;
@synthesize btn7 = _btn7;
@synthesize btn8 = _btn8;
@synthesize btn9 = _btn9;

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
- (void)setConversionType:(enum ConverterType)cType{
    
    convertType = cType;
}

#pragma mark - override
- (void)customizeView{
    
    self.title = [[ConverterManager sharedConverterManager] getTitleForConverterType:convertType];
    
    //display back  instead of last view controller title
    self.navigationController.navigationBar.backItem.title = @"Back";
    
    //Nav bar tint color
    [self.navigationController.navigationBar setBarTintColor:[self requestUIData:@"Converter/NavBar/BarColor"]];
    
    //Nav bar title font, size and color
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    [titleBarAttributes setValue:[UIFont fontWithName:[self requestUIData:@"Converter/NavBar/TitleFont"] size:[[self requestUIData:@"Converter/NavBar/TitleSize"] floatValue]] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[self requestUIData:@"Converter/NavBar/TitleFontColor"]forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    //Nav bar Translucent
    [self.navigationController.navigationBar setTranslucent:[[self requestUIData:@"Converter/NavBar/Translucent"] boolValue]];
    
    //Nav bar background alpha
    [(UIView*)[self.navigationController.navigationBar.subviews objectAtIndex:0] setAlpha:[[self requestUIData:@"Converter/NavBar/BarAlpha"] floatValue]];
    
    //Background image
    [_bgImageView setImage:[UIImage imageNamed:[self requestUIData:@"Converter/BgImg"]]];
    
    //Separator
    [_separatorImageView setImage:[UIImage imageNamed:[self requestUIData:@"Converter/SeparatorImg"]]];
    
    //top input view
    [_topInputView setInputViewType:CInputTop];
    [_topInputView customizeView];
    
    //down input view
    [_downInputView setInputViewType:CInputDown];
    [_downInputView customizeView];
    
    //Clear button
    [_btnClear setImage:[Helper imageName:[self requestUIData:@"Converter/BtnClear/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnClear/TintColor"]] forState:UIControlStateNormal];
    [_btnClear setImage:[Helper imageName:[self requestUIData:@"Converter/BtnClear/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnClear/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btnClear setBackgroundImage:[self requestUIData:@"Converter/BtnClear/BgImg"] forState:UIControlStateNormal];
    [_btnClear.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/BtnClear/TextFont"] size:[[self requestUIData:@"Converter/BtnClear/TextSize"] floatValue]]];
    [_btnClear setTitleColor:[self requestUIData:@"Converter/BtnClear/TextColor"] forState:UIControlStateNormal];
    [_btnClear setTitleColor:[self requestUIData:@"Converter/BtnClear/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btnClear setBackgroundColor:[self requestUIData:@"Converter/BtnClear/BgColor"]];
     
    
    //Backward button
    [_btnBackward setImage:[Helper imageName:[self requestUIData:@"Converter/BtnBackward/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnBackward/TintColor"]] forState:UIControlStateNormal];
    [_btnBackward setImage:[Helper imageName:[self requestUIData:@"Converter/BtnBackward/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnBackward/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btnBackward setBackgroundImage:[self requestUIData:@"Converter/BtnBackward/BgImg"] forState:UIControlStateNormal];
    [_btnBackward.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/BtnBackward/TextFont"] size:[[self requestUIData:@"Converter/BtnBackward/TextSize"] floatValue]]];
    [_btnBackward.titleLabel setTextColor:[self requestUIData:@"Converter/BtnBackward/TextColor"]];
    [_btnBackward setBackgroundColor:[self requestUIData:@"Converter/BtnBackward/BgColor"]];
    
    //Dot button
    [_btnDot setImage:[Helper imageName:[self requestUIData:@"Converter/BtnDot/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnDot/TintColor"]] forState:UIControlStateNormal];
    [_btnDot setImage:[Helper imageName:[self requestUIData:@"Converter/BtnDot/FrontImg"] withTintColor:[self requestUIData:@"Converter/BtnDot/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btnDot setBackgroundImage:[self requestUIData:@"Converter/BtnDot/BgImg"] forState:UIControlStateNormal];
    [_btnDot.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/BtnDot/TextFont"] size:[[self requestUIData:@"Converter/BtnDot/TextSize"] floatValue]]];
    [_btnDot setBackgroundColor:[self requestUIData:@"Converter/BtnDot/BgColor"]];
    
    //Button 0
    [_btn0 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn0/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn0/TintColor"]] forState:UIControlStateNormal];
    [_btn0 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn0/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn0/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn0 setBackgroundImage:[self requestUIData:@"Converter/Btn0/BgImg"] forState:UIControlStateNormal];
    [_btn0.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn0/TextFont"] size:[[self requestUIData:@"Converter/Btn0/TextSize"] floatValue]]];
    [_btn0 setTitleColor:[self requestUIData:@"Converter/Btn0/TextColor"] forState:UIControlStateNormal];
    [_btn0 setTitleColor:[self requestUIData:@"Converter/Btn0/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn0 setBackgroundColor:[self requestUIData:@"Converter/Btn0/BgColor"]];
    
    //Button 1
    [_btn1 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn1/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn1/TintColor"]] forState:UIControlStateNormal];
    [_btn1 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn1/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn1/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn1 setBackgroundImage:[self requestUIData:@"Converter/Btn1/BgImg"] forState:UIControlStateNormal];
    [_btn1.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn1/TextFont"] size:[[self requestUIData:@"Converter/Btn1/TextSize"] floatValue]]];
    [_btn1 setTitleColor:[self requestUIData:@"Converter/Btn1/TextColor"] forState:UIControlStateNormal];
    [_btn1 setTitleColor:[self requestUIData:@"Converter/Btn1/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn1 setBackgroundColor:[self requestUIData:@"Converter/Btn1/BgColor"]];
    
    //Button 2
    [_btn2 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn2/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn2/TintColor"]] forState:UIControlStateNormal];
    [_btn2 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn2/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn2/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn2 setBackgroundImage:[self requestUIData:@"Converter/Btn2/BgImg"] forState:UIControlStateNormal];
    [_btn2.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn2/TextFont"] size:[[self requestUIData:@"Converter/Btn2/TextSize"] floatValue]]];
    [_btn2 setTitleColor:[self requestUIData:@"Converter/Btn2/TextColor"] forState:UIControlStateNormal];
    [_btn2 setTitleColor:[self requestUIData:@"Converter/Btn2/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn2 setBackgroundColor:[self requestUIData:@"Converter/Btn2/BgColor"]];
    
    //Button 3
    [_btn3 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn3/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn3/TintColor"]] forState:UIControlStateNormal];
    [_btn3 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn3/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn3/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn3 setBackgroundImage:[self requestUIData:@"Converter/Btn3/BgImg"] forState:UIControlStateNormal];
    [_btn3.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn3/TextFont"] size:[[self requestUIData:@"Converter/Btn3/TextSize"] floatValue]]];
    [_btn3 setTitleColor:[self requestUIData:@"Converter/Btn3/TextColor"] forState:UIControlStateNormal];
    [_btn3 setTitleColor:[self requestUIData:@"Converter/Btn3/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn3 setBackgroundColor:[self requestUIData:@"Converter/Btn3/BgColor"]];
    
    //Button 4
    [_btn4 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn4/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn4/TintColor"]] forState:UIControlStateNormal];
    [_btn4 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn4/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn4/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn4 setBackgroundImage:[self requestUIData:@"Converter/Btn4/BgImg"] forState:UIControlStateNormal];
    [_btn4.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn4/TextFont"] size:[[self requestUIData:@"Converter/Btn4/TextSize"] floatValue]]];
    [_btn4 setTitleColor:[self requestUIData:@"Converter/Btn4/TextColor"] forState:UIControlStateNormal];
    [_btn4 setTitleColor:[self requestUIData:@"Converter/Btn4/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn4 setBackgroundColor:[self requestUIData:@"Converter/Btn4/BgColor"]];
    
    //Button 5
    [_btn5 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn5/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn5/TintColor"]] forState:UIControlStateNormal];
    [_btn5 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn5/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn5/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn5 setBackgroundImage:[self requestUIData:@"Converter/Btn5/BgImg"] forState:UIControlStateNormal];
    [_btn5.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn5/TextFont"] size:[[self requestUIData:@"Converter/Btn5/TextSize"] floatValue]]];
    [_btn5 setTitleColor:[self requestUIData:@"Converter/Btn5/TextColor"] forState:UIControlStateNormal];
    [_btn5 setTitleColor:[self requestUIData:@"Converter/Btn5/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn5 setBackgroundColor:[self requestUIData:@"Converter/Btn5/BgColor"]];
    
    //Button 6
    [_btn6 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn6/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn6/TintColor"]] forState:UIControlStateNormal];
    [_btn6 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn6/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn6/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn6 setBackgroundImage:[self requestUIData:@"Converter/Btn6/BgImg"] forState:UIControlStateNormal];
    [_btn6.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn6/TextFont"] size:[[self requestUIData:@"Converter/Btn6/TextSize"] floatValue]]];
    [_btn6 setTitleColor:[self requestUIData:@"Converter/Btn6/TextColor"] forState:UIControlStateNormal];
    [_btn6 setTitleColor:[self requestUIData:@"Converter/Btn6/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn6 setBackgroundColor:[self requestUIData:@"Converter/Btn6/BgColor"]];
    
    //Button 7
    [_btn7 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn7/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn7/TintColor"]] forState:UIControlStateNormal];
    [_btn7 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn7/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn7/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn7 setBackgroundImage:[self requestUIData:@"Converter/Btn7/BgImg"] forState:UIControlStateNormal];
    [_btn7.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn7/TextFont"] size:[[self requestUIData:@"Converter/Btn7/TextSize"] floatValue]]];
    [_btn7 setTitleColor:[self requestUIData:@"Converter/Btn7/TextColor"] forState:UIControlStateNormal];
    [_btn7 setTitleColor:[self requestUIData:@"Converter/Btn7/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn7 setBackgroundColor:[self requestUIData:@"Converter/Btn7/BgColor"]];

    
    //Button 8
    [_btn8 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn8/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn8/TintColor"]] forState:UIControlStateNormal];
    [_btn8 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn8/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn8/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn8 setBackgroundImage:[self requestUIData:@"Converter/Btn8/BgImg"] forState:UIControlStateNormal];
    [_btn8.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn8/TextFont"] size:[[self requestUIData:@"Converter/Btn8/TextSize"] floatValue]]];
    [_btn8 setTitleColor:[self requestUIData:@"Converter/Btn8/TextColor"] forState:UIControlStateNormal];
    [_btn8 setTitleColor:[self requestUIData:@"Converter/Btn8/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn8 setBackgroundColor:[self requestUIData:@"Converter/Btn8/BgColor"]];
    
    //Button 9
    [_btn9 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn9/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn9/TintColor"]] forState:UIControlStateNormal];
    [_btn9 setImage:[Helper imageName:[self requestUIData:@"Converter/Btn9/FrontImg"] withTintColor:[self requestUIData:@"Converter/Btn9/HighlightTextColor"]] forState:UIControlStateHighlighted];
    [_btn9 setBackgroundImage:[self requestUIData:@"Converter/Btn9/BgImg"] forState:UIControlStateNormal];
    [_btn9.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/Btn9/TextFont"] size:[[self requestUIData:@"Converter/Btn9/TextSize"] floatValue]]];
    [_btn9 setTitleColor:[self requestUIData:@"Converter/Btn9/TextColor"] forState:UIControlStateNormal];
    [_btn9 setTitleColor:[self requestUIData:@"Converter/Btn9/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_btn9 setBackgroundColor:[self requestUIData:@"Converter/Btn9/BgColor"]];
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
