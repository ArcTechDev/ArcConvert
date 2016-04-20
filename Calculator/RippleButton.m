//
//  RippleButton.m
//  RippleEffect
//
//  Created by User on 19/4/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import "RippleButton.h"

@implementation RippleButton{
    
    CAShapeLayer *rippleLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self=[super initWithCoder:aDecoder]){
        
        [self addTarget:self action:@selector(startRipple) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)startRipple{
    
    if(rippleLayer == nil){
        
        rippleLayer = [CAShapeLayer layer];
        CGFloat size  = MAX(self.bounds.size.width, self.bounds.size.height);
        CGPoint origin = CGPointMake((self.bounds.size.width - size)/2.0f, (self.bounds.size.height - size)/2.0f);
        rippleLayer.frame = CGRectMake(origin.x, origin.y, size, size);
        rippleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size, size)].CGPath;
        rippleLayer.fillColor = [UIColor whiteColor].CGColor;
        
    }
    
    [self.layer addSublayer:rippleLayer];
    [self.superview bringSubviewToFront:self];
    
    /*
    CABasicAnimation *fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.2f];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnim.duration = .2f;
    */
    
    CAKeyframeAnimation *kFadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    kFadeAnim.calculationMode = kCAAnimationLinear;
    kFadeAnim.keyTimes = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f]];
    kFadeAnim.values = @[[NSNumber numberWithFloat:0.2f], [NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f]];
    kFadeAnim.duration = .35f;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    scaleAnim.toValue = [NSNumber numberWithFloat:1.0f];
    scaleAnim.duration = .35f;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:.35f];
    [group setDelegate:self];
    [group setAnimations:[NSArray arrayWithObjects:kFadeAnim, scaleAnim, nil]];
    [group setRepeatCount:1];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;

    
    
    [rippleLayer addAnimation:group forKey:@"scale"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished{
    
    [rippleLayer removeFromSuperlayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
