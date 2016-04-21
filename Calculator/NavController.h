//
//  NavController.h
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>

@interface NavController : UINavigationController<UINavigationControllerDelegate, ADBannerViewDelegate>

- (void)showAdWithFrame:(CGRect)frame;
- (void)addTransitionAnimation:(id<UIViewControllerAnimatedTransitioning>)anim forViewController:(UIViewController *)viewController;

@end
