//
//  RecordMenuViewController.h
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@protocol RecordMenuViewDelegate<NSObject>

@optional
- (void)onRecordSelectedWithIndex:(NSUInteger)index;

@end

@interface RecordMenuViewController : DelegateViewController<UITableViewDataSource, UITableViewDelegate>

@end
