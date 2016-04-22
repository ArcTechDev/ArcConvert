//
//  NavController.h
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>

#define adbannerHeight 50.0f
#define adbannerAnimDuration 1.0f

@interface NavController : UINavigationController<UINavigationControllerDelegate, ADBannerViewDelegate>

- (void)showAdWithFrame:(CGRect)frame;
- (void)showAd;
- (void)addTransitionAnimation:(id<UIViewControllerAnimatedTransitioning>)anim forViewController:(UIViewController *)viewController;

@end
