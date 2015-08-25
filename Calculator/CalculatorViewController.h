//
//  ViewController.h
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "RecordManager.h"
#import "RecordMenuViewController.h"
#import  <iAd/iAd.h>

#define kAnimationDuration 0.2

enum InputType{
    
    Unknow,
    Equal,
    Digital,
    Operator
};

@interface CalculatorViewController : UIViewController<LeftMenuViewDelegate, RecordManagerDelegate, RecordMenuViewDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayField;
//@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *dispalyCalculation;
@property (weak, nonatomic) IBOutlet ADBannerView *adbannerView;


@end

