//
//  DelegateViewController.m
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "DelegateViewController.h"

@interface DelegateViewController ()

- (id)requestCustomizedUIDataWithPathString:(NSString *)pathString;

@end

@implementation DelegateViewController{
    
    __weak ThemeManager *themeMgr;
}

@synthesize delegate = _delegate;
@synthesize showNavigationBar = _showNavigationBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    themeMgr = [ThemeManager sharedThemeManager];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self customizeView];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
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
    
    
}

- (id)requestUIData:(NSString *)pathString{
    
    return [themeMgr requestCustomizedUIDataWithPathString:pathString];
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
