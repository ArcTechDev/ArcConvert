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
#import "ConverterManager.h"

//the max of digital include decimal user can input 
#define conversionMaxDigitalInput 12

enum WorkingUnit{
    
    TopUnit,
    DownUnit
};

enum SelectUnit{
    
    SelectUnknowUnit,
    SelectTopUnit,
    SelectDownUnit
};

@interface ConverterViewController : UIViewController<UnitPickViewDelegate, FPPopoverControllerDelegate>

- (void)setConversionType:(NSUInteger)cType;

@end
