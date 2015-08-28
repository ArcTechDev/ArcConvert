//
//  UnitPickViewController.h
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@protocol UnitPickViewDelegate <NSObject>

- (void)onUnitPickViewSelectUnitAtIndex:(NSUInteger)index withUnitName:(NSString *)UnitName;

@end

@interface UnitPickViewController : DelegateViewController<UITableViewDataSource, UITableViewDelegate>

@property (setter=setUnits:, nonatomic) NSArray *unitToDisplay;

@end
