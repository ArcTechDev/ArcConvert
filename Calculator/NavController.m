//
//  NavController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "NavController.h"
#import  <iAd/iAd.h>

@interface NavController ()

@end

@implementation NavController{
    
    ADBannerView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAdWithFrame:(CGRect)frame{
    
    if(adView == nil){
        
        adView = [[ADBannerView alloc] initWithFrame:frame];
        
        [self.view addSubview: adView];
    }
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
