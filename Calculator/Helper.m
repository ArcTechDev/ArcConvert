//
//  Helper.m
//  Calculator
//
//  Created by User on 20/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)getDocumentDirectoryPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return  [paths objectAtIndex:0];
}


+ (NSString *)getUnicodeStringFromString:(NSString *)string{
    
    return [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
}

+ (BOOL)findCharacterInStringWithString:(NSString *)stringToFind WithCharacter:(NSString *)character{
    
    if([stringToFind isEqualToString:@""] || [character isEqualToString:@""])
        return NO;
    
    if([stringToFind rangeOfString:character options:NSLiteralSearch].location == NSNotFound)
        return NO;
    else
        return YES;
}

+(NSString *)trimeStringWithString:(NSString *)string preserveCharacterCount:(NSUInteger)preserveCount{
    
    if(string.length <= 0 || string.length<=preserveCount)
        return string;
    
    return [string substringWithRange:NSMakeRange(0, preserveCount)];
}

+ (UIImage *)imageName:(NSString *)imageName withTintColor:(UIColor *)tintColor{
    
    UIImage *img = [UIImage imageNamed:imageName];
    
    UIGraphicsBeginImageContext(img.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [tintColor setFill];
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *tintColorImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintColorImg;
}

@end
