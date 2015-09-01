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

@end
