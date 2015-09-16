//
//  UnitPickCell.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "UnitPickCell.h"
#import "SelectInnerGlow.h"
#import "ThemeManager.h"

@interface UnitPickCell ()

@end

@implementation UnitPickCell

@synthesize titleLabel = _titleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if(selected){
        
        if(![self.selectedBackgroundView respondsToSelector:@selector(select)])
            return;
        
        [(SelectInnerGlow*)self.selectedBackgroundView setGlowColor:[[ThemeManager sharedThemeManager] requestCustomizedUIDataWithPathString:@"Converter/UnitPicker/SelectGlowColor"]];
        [(SelectInnerGlow*)self.selectedBackgroundView select];
    }
    else{
        
        if(![self.selectedBackgroundView respondsToSelector:@selector(deSelect)])
            return;
        
        [(SelectInnerGlow*)self.selectedBackgroundView deSelect];
    }
}

@end
