//
//  ThemePickerCell.m
//  Calculator
//
//  Created by User on 10/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ThemePickerCell.h"

@interface ThemePickerCell ()

@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ThemePickerCell{
    
    BOOL isSelected;
    
    CALayer *subLayer;
}

@synthesize themSelected = _themSelected;
@synthesize imageView = _imageView;

- (void)setThemeImage:(UIImage *)themeImage{
    
    [_imageView setImage:themeImage];
}

- (void)setThemeSelect:(BOOL)themSelected{
    
    isSelected = themSelected;
    
    if(themSelected == YES){
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 5;
    }
    else{
        
        self.layer.borderWidth = 0;
    }
}

- (BOOL)isThemeSelect{
    
    return isSelected;
}

@end
