//
//  ConverterInputView.m
//  Calculator
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ConverterInputView.h"
#import "Helper.h"

@interface ConverterInputView ()

@property(weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property(weak, nonatomic) IBOutlet UILabel *inputLabel;
@property(weak, nonatomic) IBOutlet UILabel *unitLabel;
@property(weak, nonatomic) IBOutlet UIImageView *dropDownArrowImageView;

@end

@implementation ConverterInputView{
    
    enum ConverterInputViewType currentType;
}

@synthesize indicatorImageView = _indicatorImageView;
@synthesize inputLabel = _inputLabel;
@synthesize unitLabel = _unitLabel;
@synthesize dropDownArrowImageView = _dropDownArrowImageView;

#pragma mark - public interface
- (void)setInputViewType:(enum ConverterInputViewType)type{
    
    currentType = type;
}

#pragma mark - override
- (void)customizeView{
    
    switch (currentType) {
        case CInputTop:
            
            //indicator image and tint color
            [_indicatorImageView setImage:[Helper imageName:[self requestUIData:@"Converter/TopInput/IndicatorImg"] withTintColor:[self requestUIData:@"Converter/TopInput/IndicatorTintColor"]]];
            
            //input label font and size
            [_inputLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/TopInput/InputTextFont"] size:[[self requestUIData:@"Converter/TopInput/InputTextSize"] floatValue]]];
            
            //input label color
            [_inputLabel setTextColor:[self requestUIData:@"Converter/TopInput/InputTextColor"]];
            
            //unit label font and size
            [_unitLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/TopInput/UnitTextFont"] size:[[self requestUIData:@"Converter/TopInput/UnitTextSize"] floatValue]]];
            
            //unit label color
            [_unitLabel setTextColor:[self requestUIData:@"Converter/TopInput/UnitTextColor"]];
            
            //drop down arrow image and tint color
            [_dropDownArrowImageView setImage:[Helper imageName:[self requestUIData:@"Converter/TopInput/DropDownArrowImg"] withTintColor:[self requestUIData:@"Converter/TopInput/DropDownArrowTintColor"]]];
            
            //background color
            self.backgroundColor = [self requestUIData:@"Converter/TopInput/BgColor"];
            
            break;
            
        case CInputDown:
            
            //indicator image and tint color
            [_indicatorImageView setImage:[Helper imageName:[self requestUIData:@"Converter/DownInput/IndicatorImg"] withTintColor:[self requestUIData:@"Converter/DownInput/IndicatorTintColor"]]];
            
            //input label font and size
            [_inputLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/DownInput/InputTextFont"] size:[[self requestUIData:@"Converter/DownInput/InputTextSize"] floatValue]]];
            
            //input label color
            [_inputLabel setTextColor:[self requestUIData:@"Converter/DownInput/InputTextColor"]];
            
            //unit label font and size
            [_unitLabel setFont:[UIFont fontWithName:[self requestUIData:@"Converter/DownInput/UnitTextFont"] size:[[self requestUIData:@"Converter/DownInput/UnitTextSize"] floatValue]]];
            
            //unit label color
            [_unitLabel setTextColor:[self requestUIData:@"Converter/DownInput/UnitTextColor"]];
            
            //drop down arrow image and tint color
            [_dropDownArrowImageView setImage:[Helper imageName:[self requestUIData:@"Converter/DownInput/DropDownArrowImg"] withTintColor:[self requestUIData:@"Converter/DownInput/DropDownArrowTintColor"]]];
            
            //background color
            self.backgroundColor = [self requestUIData:@"Converter/DownInput/BgColor"];
            
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
