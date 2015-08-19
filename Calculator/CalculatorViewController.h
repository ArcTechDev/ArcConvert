//
//  ViewController.h
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

#define kAnimationDuration 0.2

@interface CalculatorViewController : UIViewController<LeftMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayField;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

