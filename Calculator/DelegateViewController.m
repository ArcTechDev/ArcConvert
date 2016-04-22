//
//  DelegateViewController.m
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "DelegateViewController.h"
#import "AppDelegate.h"

@interface DelegateViewController ()

@end

@implementation DelegateViewController{
    
    __weak ThemeManager *themeMgr;
    BOOL isCustomize;
}

@synthesize delegate = _delegate;
@synthesize showNavigationBar = _showNavigationBar;
@synthesize tutorialView = _tutorialView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    themeMgr = [ThemeManager sharedThemeManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onThemeSwitch:) name:ThemChangeNotify object:nil];
    isCustomize = NO;
    
    
    if(_tutorialView != nil){
        
        [_tutorialView setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:!_showNavigationBar animated:NO];
    
    if(!isCustomize){
        
        [self customizeView];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //When use interactive pop gesture and there are some view controller
    //has hidden navigation bar, we have to unhide the bar when that view controller
    //is about to disppear so navigation bar will not mess up
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self presentTutorial];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public  interface
- (void)addToParentViewController:(UIViewController *)parent{
    
    [parent addChildViewController:self];
    
    [parent.view addSubview:self.view];
    
    [self didMoveToParentViewController:parent];
}

- (void)onPushIntoNavigationController{
    
}

- (void)customizeView{
    
    isCustomize = YES;
}

- (id)requestUIData:(NSString *)pathString{
    
    return [themeMgr requestCustomizedUIDataWithPathString:pathString];
}

- (void)presentTutorial{
    
    [[TutorialManager sharedManager] presentTutorialWithKey:NSStringFromClass([self class]) WithDelegate:self WithViewController:[self getTutorialViewController] WithDismissGesture:[self dismissTutorialGesture]];
}

- (UIViewController *)getTutorialViewController{
    
    return nil;
}

- (UIGestureRecognizer *)dismissTutorialGesture{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTouchesRequired:1];
    
    return tapGesture;
}

- (void)dismissTutorialView{
    
}

- (void)animationFinished{
    
}

- (void)showAdBannerConstraintWithValue:(CGFloat)value withAnimDuration:(CGFloat)duration{
    
    if(_adbannerConstraint){
        
        _adbannerConstraint.constant = value;
        
        [UIView animateWithDuration:duration animations:^{
        
            [self.view layoutIfNeeded];
        }];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            if(finished){
                
                [self animationFinished];
            }
        }];
    }
}

- (void)updateAdBannerConstraintWithValue:(CGFloat)value{
    
    _adbannerConstraint.constant = value;
    
    [self.view layoutIfNeeded];
}

#pragma mark - TutorialManager delegate
- (void)onTutorialDismissWithViewController:(UIViewController *)viewController{
    
}

#pragma mark - ThemeManager notify
- (void)onThemeSwitch:(NSNotification *)notification{
    
    isCustomize = NO;
    
    if(self.navigationController.topViewController == self)
        [self customizeView];
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
