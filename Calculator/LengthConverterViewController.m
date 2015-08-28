//
//  LengthConverterViewController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "LengthConverterViewController.h"

@interface LengthConverterViewController ()

@end

@implementation LengthConverterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPopover:(id)sender{
    
    [self showUnitPickerFromView:sender withUnitStrings:[NSArray arrayWithObjects:@"unit1",@"unit2",@"unit3",@"unit4",@"unit5", nil]];
    
}

- (void)onUnitPickViewSelectUnitAtIndex:(NSUInteger)index withUnitName:(NSString *)UnitName{
    
    NSLog(@"%@", UnitName);
    
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
