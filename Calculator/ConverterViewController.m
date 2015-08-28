//
//  ConverterViewController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ConverterViewController.h"

@interface ConverterViewController ()

@property (retain, nonatomic) FPPopoverController *popController;

@end

@implementation ConverterViewController

@synthesize popController = _popController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public interface
- (void)showUnitPickerFromView:(id)view withUnitStrings:(NSArray *)unitStrings{
    
    if(_popController == nil){
        
        UnitPickViewController *unitPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitPickView"];
        
        ((DelegateViewController *)unitPicker).delegate = self;
        
        unitPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        
        _popController = [[FPPopoverController alloc] initWithViewController:unitPicker];
        
        _popController.delegate = self;
        
        _popController.contentSize = CGSizeMake(unitPicker.view.frame.size.width, unitPicker.view.frame.size.height);
        
        unitPicker.unitToDisplay = unitStrings;
        
        [_popController presentPopoverFromView:view];
    }
    else{
        
        [_popController dismissPopoverAnimated:YES completion:nil];
    }
    
}

#pragma mark - UnitPickViewConrtoller delegate
/**
 * Subclass override to receive unit pick view callback for unit select
 */
- (void)onUnitPickViewSelectUnitAtIndex:(NSUInteger)index withUnitName:(NSString *)UnitName{
    
}

#pragma mark - FPPopoverViewController delegate
/**
 * Subclass override
 */
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController shouldDismissVisiblePopover:(FPPopoverController *)visiblePopoverController{
    
}

/**
 * Subclass override
 */
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController{
    
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
