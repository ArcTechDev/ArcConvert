//
//  MainMenuBtnView.h
//  Calculator
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateView.h"
#import "ConverterManager.h"

enum ButtonViewType{
    
    BLength,
    BTemperature,
    BSpeed,
    BArea,
    BVolume,
    BWeight,
    BTime,
    BData,
    BCurrency,
    BTheme,
    BCalculator,
    BInformation
};

@interface MainMenuBtnView : DelegateView

- (void)setButtonViewType:(enum ButtonViewType)type;

@end
