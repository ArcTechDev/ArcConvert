//
//  NavController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "NavController.h"
#import "DelegateViewController.h"
#import  <iAd/iAd.h>
#import "MainMenuViewController.h"

@interface NavController ()

@end

@implementation NavController{
    
    ADBannerView *adView;
    NSMutableDictionary *animationDic;
    CGRect adRect;
    BOOL adLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAdWithFrame:(CGRect)frame{
    
    if(adView == nil){
        
        adLoaded = NO;
        adView = [[ADBannerView alloc] initWithFrame:frame];
        adView.delegate = self;
        
        [self.view addSubview: adView];
    }
}

- (void)showAd{
    
    if(adView == nil){
        
        adRect = CGRectMake(0, self.view.frame.size.height-adbannerHeight, [UIScreen mainScreen].bounds.size.width, adbannerHeight);
        
        //adView = [[ADBannerView alloc] initWithFrame:CGRectMake(adRect.origin.x, self.view.frame.size.height, adRect.size.width, adRect.size.height)];
        adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        adView.frame = CGRectMake(adRect.origin.x, self.view.frame.size.height, adRect.size.width, adRect.size.height);
        adView.delegate = self;
        
        [self.view addSubview: adView];
    }
}

- (void)addTransitionAnimation:(id<UIViewControllerAnimatedTransitioning>)anim forViewController:(UIViewController *)viewController{
    
    if(animationDic == nil){
        
        animationDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass([viewController class]);
    
    if([animationDic valueForKey:className] == nil){
        
        [animationDic setValue:anim forKey:className];
    }
}

- (void)moveAdOnScreen{
    
    [self.view.layer removeAllAnimations];
    
    DelegateViewController *controller = (DelegateViewController *)[self topViewController];
    
    [controller.view.layer removeAllAnimations];
    
    [controller showAdBannerConstraintWithValue:adbannerHeight withAnimDuration:adbannerAnimDuration];
    
    [UIView animateWithDuration:adbannerAnimDuration animations:^{
    
    
        adView.frame = adRect;
    }];
}

- (void)moveAdOffScreen{
    
    [self.view.layer removeAllAnimations];
    
    DelegateViewController *controller = (DelegateViewController *)[self topViewController];
    
    [controller.view.layer removeAllAnimations];
    
    [controller showAdBannerConstraintWithValue:0 withAnimDuration:adbannerAnimDuration];
    
    [UIView animateWithDuration:adbannerAnimDuration animations:^{
        
        adView.frame = CGRectMake(adRect.origin.x, self.view.frame.size.height, adRect.size.width, adRect.size.height);
    }];
}

#pragma mark - UINavigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if([viewController isKindOfClass:[DelegateViewController class]]){
        
        DelegateViewController *controller = (DelegateViewController *)viewController;
        
        if(adLoaded){
            
            if(adView.frame.origin.y == adRect.origin.y)
                [controller updateAdBannerConstraintWithValue:adbannerHeight];
            else
                [controller showAdBannerConstraintWithValue:adbannerHeight withAnimDuration:adbannerAnimDuration];
        }
        else{
            
            //[controller updateAdBannerConstraintWithValue:0.0f];
            [controller showAdBannerConstraintWithValue:0.0f withAnimDuration:0.3f];
        }
        
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
 
    NSString *className = NSStringFromClass([fromVC class]);
    
    if(animationDic != nil && [animationDic valueForKey:className] != nil){
        
        return [animationDic valueForKey:className];
    }
    
    return nil;
}

#pragma mark - ADBannerView delegate
- (void)bannerViewWillLoadAd:(ADBannerView *)banner{

    NSLog(@"Will load ad banner");
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    NSLog(@"Ad banner loaded");
    
    adLoaded = YES;
    
    [self moveAdOnScreen];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    NSLog(@"Unable to show ad banner %@", error);
    
    adLoaded = NO;
    
    [self moveAdOffScreen];
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
