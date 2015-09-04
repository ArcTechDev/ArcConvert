//
//  DelegateView.h
//  Calculator
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface DelegateView : UIView

@property(weak, nonatomic) id delegate;

- (void)customizeView;

- (id)requestUIData:(NSString *)pathString;

@end
