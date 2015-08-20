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

@end
