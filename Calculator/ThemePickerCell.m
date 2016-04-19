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
    UIView *maskView;
}

@synthesize themSelected = _themSelected;
@synthesize imageView = _imageView;

- (void)setThemeImage:(UIImage *)themeImage{
    
    [_imageView setImage:themeImage];
}

- (void)setThemeSelect:(BOOL)themSelected{
    
    isSelected = themSelected;
    
    if(maskView == nil){
        
        /*
        subLayer = [CALayer layer];
        subLayer.bounds = CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.height);
        subLayer.backgroundColor = [UIColor whiteColor].CGColor;
        subLayer.opacity = 0.5f;
        */
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.height)];
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.alpha = 0.7f;

    }
    
    if(themSelected == YES){
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 5;
        [self.layer addSublayer:maskView.layer];
    }
    else{
        
        [maskView.layer removeFromSuperlayer];
        self.layer.borderWidth = 0;
    }
}

- (BOOL)isThemeSelect{
    
    return isSelected;
}

@end
