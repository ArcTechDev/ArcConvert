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
#import "CategoryEx.h"
#import "NavController.h"
#import "DelegateViewController.h"

#define kAnimationDuration 0.2

//the max of digital include decimal user can input
#define calculatorMaxDigitalInput 12

enum InputType{
    
    Unknow,
    Equal,
    Digital,
    Operator
};

@interface CalculatorViewController : DelegateViewController<LeftMenuViewDelegate, RecordManagerDelegate, RecordMenuViewDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayField;
@property (weak, nonatomic) IBOutlet UILabel *dispalyCalculation;


@end

