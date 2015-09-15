//
//  RecordMenuCell.m
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "RecordMenuCell.h"
#import "SelectInnerGlow.h"
#import "ThemeManager.h"


@implementation RecordMenuCell

@synthesize processLabel = _processLabel;
@synthesize sumLabel = _sumLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if(selected){
        
        [(SelectInnerGlow*)self.selectedBackgroundView setGlowColor:[[ThemeManager sharedThemeManager] requestCustomizedUIDataWithPathString:@"History/SelectGlowColor"]];
        [(SelectInnerGlow*)self.selectedBackgroundView select];
    }
    else{
        
        [(SelectInnerGlow*)self.selectedBackgroundView deSelect];
    }
}

- (void)highlight{
    
    [(SelectInnerGlow*)self.selectedBackgroundView setGlowColor:[[ThemeManager sharedThemeManager] requestCustomizedUIDataWithPathString:@"History/SelectGlowColor"]];
    [(SelectInnerGlow*)self.selectedBackgroundView select];
}

- (void)unhighlight{
    
    [(SelectInnerGlow*)self.selectedBackgroundView deSelect];
}

@end
