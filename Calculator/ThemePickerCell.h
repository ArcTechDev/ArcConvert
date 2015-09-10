//
//  ThemePickerCell.h
//  Calculator
//
//  Created by User on 10/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemePickerCell : UICollectionViewCell

@property(setter=setThemeSelect:,getter=isThemeSelect,assign, nonatomic) BOOL themSelected;

- (void)setThemeImage:(UIImage *)themeImage;


@end
