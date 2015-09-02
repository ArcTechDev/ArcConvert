//
//  DelegateViewController.h
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateViewController : UIViewController

@property(weak, nonatomic) id delegate;
@property(assign, nonatomic) BOOL showNavigationBar;

/**
 * Add this ViewController to given parent ViewController
 *
 * @Param parent the parent ViewController
 * Return this ViewController
 */
- (void)addToParentViewController:(UIViewController *)parent;

- (void)onPushIntoNavigationController;

@end
