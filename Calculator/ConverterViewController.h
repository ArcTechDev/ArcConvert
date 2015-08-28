//
//  ConverterViewController.h
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
#import "UnitPickViewController.h"
#import "DDUnitConversion.h"

@interface ConverterViewController : UIViewController<UnitPickViewDelegate, FPPopoverControllerDelegate>

/**
 * show popover view with unit string array
 */
- (void)showUnitPickerFromView:(id)view withUnitStrings:(NSArray *)unitStrings;

@end
