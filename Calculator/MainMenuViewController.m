//
//  MainMenuViewController.m
//  Calculator
//
//  Created by User on 24/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ConverterViewController.h"
#import "MainMenuBtnView.h"


@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIView *halfTransView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnLengthView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnTemperatureView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnSpeedView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnAreaView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnVolumeView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnWeightView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnTimeView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnDataView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnCurrencyView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnThemeView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnCalculatorView;
@property (weak, nonatomic) IBOutlet MainMenuBtnView *btnInformationView;
@property (weak, nonatomic) IBOutlet UILabel *convertTitleLabel;

@end

@implementation MainMenuViewController{
    
    //to store last translation on this view when panning
    CGPoint lastTranslation;
    
    //determine was panning left or right
    BOOL panLeft;
    
    //store previous controller's view in NavigationController
    //so we can use this view as bottom layer when panning
    //this view
    UIView *previousView;
    
    __weak UIButton *tappedButton;
}

@synthesize bgView = _bgView;
@synthesize halfTransView = _halfTransView;
@synthesize btnLengthView = _btnLengthView;
@synthesize btnTemperatureView = _btnTemperatureView;
@synthesize btnSpeedView = _btnSpeedView;
@synthesize btnAreaView = _btnAreaView;
@synthesize btnVolumeView = _btnVolumeView;
@synthesize btnWeightView = _btnWeightView;
@synthesize btnTimeView = _btnTimeView;
@synthesize btnDataView = _btnDataView;
@synthesize btnCurrencyView = _btnCurrencyView;
@synthesize btnThemeView = _btnThemeView;
@synthesize btnCalculatorView = _btnCalculatorView;
@synthesize btnInformationView = _btnInformationView;
@synthesize convertTitleLabel = _convertTitleLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showNavigationBar = NO;
    
    //register left edge pan
    /*
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePanGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
     */
    
    //show ad
    [(NavController *)self.navigationController showAdWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height-50, self.view.frame.size.width, 50)];
    
    //add transition animaitoin
    [(NavController *)self.navigationController addTransitionAnimation:[[CircleTransition alloc] initWithDelegate:self] forViewController:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"MainMenu Controller memeory warning");
}

#pragma mark - public  interface
- (void)addToParentViewController:(UIViewController *)parent{
    
    [super addToParentViewController:parent];
}

#pragma mark - Gesture
/*
- (void)handleLeftEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    //get current translation on this view
    CGPoint translation = [gesture translationInView:self.view.superview];
    
    //if it was panning left and translation x less equal to 0
    //edge pan left is positive value
    if(panLeft && translation.x <= 0.0){
        
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        return;
    }
    
    //check if pan left or right
    if(panLeft && translation.x > lastTranslation.x)
        panLeft = NO;
    else if(!panLeft && translation.x < lastTranslation.x)
        panLeft = YES;
    
    //when start pan gesture
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        //if previousView is nil we need to find it
        if(previousView == nil){
            
            int previousViewControllerIndex = 0;
            
            //find the index of previousView in NavigationController
            for(int i=0; i<self.navigationController.viewControllers.count; i++){
                
                UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:i];
                
                if(controller == self){
                    
                    previousViewControllerIndex = i-1;
                    
                    break;
                }
            }
            
            //we add previousView to this view's super view and make it as bottom layer
            if(previousViewControllerIndex >= 0){
                
                previousView = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:previousViewControllerIndex]).view;
                
                [self.view.superview addSubview:previousView];
                [self.view.superview sendSubviewToBack:previousView];
            }
        }
        
        //store last translation
        lastTranslation = translation;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged){//when pan gesture changed
        
        //calculate translation percent value  on view
        float percent = translation.x * 100.0 / self.view.frame.size.width / 100.0;
        
        self.view.frame = CGRectMake(self.view.frame.size.width * fabsf(percent), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        lastTranslation = translation;
        
    }
    else{//somehow user's pan gesture end
        
        //start animation
        [UIView animateWithDuration:0.2 animations:^{
            
            //if was pan left animate view to left
            if(panLeft){
               
                self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }
            else{//otherwise animate view to right
                
                self.view.frame = CGRectMake(self.view.superview.frame.size.width + self.view.frame.size.width/2, self.view.frame.origin.y, self.view.frame.size.width , self.view.frame.size.height);
            }
        } completion:^(BOOL finished){
            
            if(finished){
                
                //if was pan left push controller to navigation controller
                if(!panLeft){
                    
                    if(previousView != nil){
                        
                        //we must remove previousView from its super view before pop this controller
                        [previousView removeFromSuperview];
                        previousView = nil;
                    }
                    
                    [self.navigationController popViewControllerAnimated:NO];
                }
                
            }
        }];
    }
    
}
 */

#pragma mark - override
- (void)onPushIntoNavigationController{


}

- (void)customizeView{
    
    //Nav bar title
    //self.title = @"MainMenu";
    
    //Background image
    [_bgView setImage:[UIImage imageNamed:[self requestUIData:@"MainMenu/BgImg"]]];
    
    //HalfTransparent view
    [_halfTransView setBackgroundColor:[self requestUIData:@"MainMenu/HalfTransColor"]];
    
    //title color
    [_convertTitleLabel setTextColor:[self requestUIData:@"MainMenu/TitleColor"]];
    
    //Button view
    [_btnLengthView setButtonViewType:BLength];
    [_btnLengthView customizeView];
    
    [_btnTemperatureView setButtonViewType:BTemperature];
    [_btnTemperatureView customizeView];
    
    [_btnSpeedView setButtonViewType:BSpeed];
    [_btnSpeedView customizeView];
    
    [_btnAreaView setButtonViewType:BArea];
    [_btnAreaView customizeView];
    
    [_btnVolumeView setButtonViewType:BVolume];
    [_btnVolumeView customizeView];
    
    [_btnWeightView setButtonViewType:BWeight];
    [_btnWeightView customizeView];
    
    [_btnTimeView setButtonViewType:BTime];
    [_btnTimeView customizeView];
    
    [_btnDataView setButtonViewType:BData];
    [_btnDataView customizeView];
    
    [_btnCurrencyView setButtonViewType:BCurrency];
    [_btnCurrencyView customizeView];
    
    [_btnThemeView setButtonViewType:BTheme];
    [_btnThemeView customizeView];
    
    [_btnCalculatorView setButtonViewType:BCalculator];
    [_btnCalculatorView customizeView];
    
    [_btnInformationView setButtonViewType:BInformation];
    [_btnInformationView customizeView];
}

#pragma mark - IBActions
- (IBAction)goToLengthConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CLength];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToTemperatureConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CTemperature];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToSpeedConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CSpeed];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToAreaConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CArea];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToVolumeConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CVolume];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToWeightConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CWeight];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToTimeConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CTime];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToDataConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CData];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToCurrencyConverter:(id)sender{
    
    tappedButton = sender;
    
    ConverterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ConverterViewController"];
    
    [controller setConversionType:CCurrency];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToThemes:(id)sender{
    
    tappedButton = sender;
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemePickerView"];
    
    [self.navigationController pushViewController:controller animated:YES];


}

- (IBAction)goToCalculator:(id)sender{
    
    tappedButton = sender;
    
    //[self.navigationController popViewControllerAnimated:YES];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goToInformation:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://neatconvert.yabi.me"]];
}

#pragma mark - CircleTransitionDelegate
- (NSTimeInterval)transitionDuration{
    
    return 0.5f;
}

- (UIView *)transitionBeginView{
    
    if(tappedButton != nil)
        return tappedButton;
    
    return self.view;
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
