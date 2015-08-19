//
//  SlideViewController.h
//  Calculator
//
//  Created by User on 18/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MenuDirectoin{
    
    None,
    Left,
    Right
};

//
//MenuItem class
//contain data about menu item
@interface MenuItem : NSObject

@property(copy, nonatomic) NSString *itemTitle;

+ (id)createMenuItem:(NSString *)title;

@end


@protocol LeftMenuViewDelegate <NSObject>

@optional
- (void)onMenuItemSelected:(MenuItem *)item;

@end

//
//LeftMenuViewController
@interface LeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

/**
 * Define portion of menu view to show, in other word
 * how much menu view need to be showed when slide out
 * Value is multiplier between 0 ~ 1
 * Default is 0.5
 */
@property(assign, nonatomic) float maxViewToShowMultiplier;

/**
 * Acceleration of draging
 */
@property(assign, nonatomic) float acceleration;

/**
 * Get the sliding direction of view
 */
@property(getter=getDirection, nonatomic) enum MenuDirectoin direction;

/**
 * Set last touch translation
 * when user begin to pan on any of view, this value must be set to the
 * translation e.g [gesture translationInView:gesture.view] so view can calculate
 * properly
 * Do not set this value during the pan
 */
@property(setter=setLastTouchTranslation:, nonatomic) CGPoint lastTouchTranslation;

/**
 * Delegate that implement LeftMenuViewDelegate
 */
@property(weak, nonatomic)id<LeftMenuViewDelegate> delegate;


/**
 * Add this ViewController to given parent ViewController
 *
 * @Param parent the parent ViewController
 * Return this ViewController
 */
- (id)addToParentViewController:(UIViewController *)parent;

/**
 * Move menu view by given translation
 * You need to set lastTouchTranslation before given translation so it can
 * calculate amount of pan correctly
 *
 * @Param translation the translation on view that user gesture using on
 */
- (void)moveMenuViewWithTranslation:(CGPoint)translation;

/**
 * Make menu slide out
 */
- (void)slideOutWithDuration:(NSTimeInterval)duration OnComplete:(void(^)())complete;

/**
 * Make menu slide in
 */
- (void)slideInWithDuration:(NSTimeInterval)duration OnComplete:(void(^)())complete;

@end
