//
//  CircleTransition.m
//  Calculator
//
//  Created by User on 20/4/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import "CircleTransition.h"

@interface CircleTransition ()

@property (nonatomic, weak) id<CircleTransitionDelegate>delegate;

@end

@implementation CircleTransition{
    
    id<UIViewControllerContextTransitioning> transContext;
}

- (id)initWithDelegate:(id<CircleTransitionDelegate>)del{
    
    if(self = [super init]){
        
        _delegate = del;
    }
    
    return self;
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    if([_delegate respondsToSelector:@selector(transitionDuration)]){
        
        return [_delegate transitionDuration];
    }
    
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    transContext = transitionContext;
    
    UIView *animFromView = [_delegate transitionBeginView];
    
    UIView *containerView = [transitionContext containerView];
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView addSubview:toViewController.view];
    
    CGRect startRect = [animFromView convertRect:animFromView.frame toView:fromViewController.view];
    UIBezierPath *circleInitialMaskPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    
    CGPoint extremePoint = CGPointMake(animFromView.center.x, animFromView.center.y - CGRectGetHeight(toViewController.view.bounds));
    double radius = sqrt((extremePoint.x * extremePoint.x)+(extremePoint.y * extremePoint.y));
    UIBezierPath *finalMaskPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(startRect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalMaskPath.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *circleExpandAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    circleExpandAnim.fromValue = (id)circleInitialMaskPath.CGPath;
    circleExpandAnim.toValue = (id)finalMaskPath.CGPath;
    circleExpandAnim.duration = [self transitionDuration:transitionContext];
    circleExpandAnim.delegate = self;
     
    /*
    CAKeyframeAnimation *circleExpandAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    circleExpandAnim.calculationMode = kCAAnimationLinear;
    circleExpandAnim.keyTimes = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.8f], [NSNumber numberWithFloat:1.0f]];
    circleExpandAnim.values = @[circleInitialMaskPath, circleInitialMaskPath, finalMaskPath];
    circleExpandAnim.duration = [self transitionDuration:transitionContext];
    */
     
    [maskLayer addAnimation:circleExpandAnim forKey:@"CircleExpand"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [transContext completeTransition:![transContext transitionWasCancelled]];
    [transContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [transContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

@end
