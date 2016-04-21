//
//  CircleTransition.h
//  Calculator
//
//  Created by User on 20/4/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CircleTransitionDelegate <NSObject>

@required
- (UIView *)transitionBeginView;

@optional
- (NSTimeInterval)transitionDuration;


@end

@interface CircleTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (id)initWithDelegate:(id<CircleTransitionDelegate>)del;

@end
