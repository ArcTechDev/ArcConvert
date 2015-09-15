//
//  SelectInnerGlow.m
//  Calculator
//
//  Created by User on 15/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "SelectInnerGlow.h"

@implementation SelectInnerGlow{
    
    UIColor *glowColor;
    
    BOOL isSelect;
    
    float alpha;
}

- (void)setGlowColor:(UIColor *)color{
    
    glowColor = color;
}

- (void)select{
    
    self.backgroundColor = [UIColor clearColor];
    alpha = 0;
    isSelect = YES;
    [self setNeedsDisplay];
}

- (void)deSelect{
    
    self.backgroundColor = [UIColor clearColor];
    isSelect = NO;
    [self setNeedsDisplay];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if(isSelect){
        
        if(glowColor == nil){
            
            glowColor = [UIColor greenColor];
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Shadow Declarations
        UIColor* shadow = glowColor;
        CGSize shadowOffset = CGSizeMake(0, 0);
        CGFloat shadowBlurRadius = 50;
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: self.bounds];
        [[UIColor clearColor] setFill];
        [rectanglePath fill];
        
        
        ////// Rectangle Inner Shadow
        CGContextSaveGState(context);
        UIRectClip(rectanglePath.bounds);
        CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
        
        CGContextSetAlpha(context, CGColorGetAlpha([shadow CGColor]));
        CGContextBeginTransparencyLayer(context, NULL);
        {
            UIColor* opaqueShadow = [shadow colorWithAlphaComponent: 1];
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [opaqueShadow CGColor]);
            CGContextSetBlendMode(context, kCGBlendModeSourceOut);
            
            CGContextBeginTransparencyLayer(context, NULL);
            
            [opaqueShadow setFill];
            [rectanglePath fill];
            
            CGContextEndTransparencyLayer(context);
            
        }
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}


@end
