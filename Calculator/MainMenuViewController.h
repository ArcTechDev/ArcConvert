//
//  MainMenuViewController.h
//  Calculator
//
//  Created by User on 24/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"
#import  <iAd/iAd.h>
#import "NavController.h"
#import "CircleTransition.h"



@interface MainMenuViewController : DelegateViewController<ADBannerViewDelegate, CircleTransitionDelegate>


@end
