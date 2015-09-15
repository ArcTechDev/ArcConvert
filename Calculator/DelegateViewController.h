//
//  DelegateViewController.h
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "TutorialManager.h"

@interface DelegateViewController : UIViewController<UIGestureRecognizerDelegate, TutorialManagerDelegate>

@property(weak, nonatomic) id delegate;
@property(assign, nonatomic) BOOL showNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;

/**
 * Add this ViewController to given parent ViewController
 *
 * @Param parent the parent ViewController
 * Return this ViewController
 */
- (void)addToParentViewController:(UIViewController *)parent;

- (void)onPushIntoNavigationController;

- (void)customizeView;

- (id)requestUIData:(NSString *)pathString;

- (void)presentTutorial;

/**
 * override and return tutorial view controller
 */
- (UIViewController *)getTutorialViewController;

/**
 * overrde and return gesture that used to dismiss tutorial view
 */
- (UIGestureRecognizer *)dismissTutorialGesture;

/**
 * override to receive tutorial view dismiss notify
 */
- (void)dismissTutorialView;

@end
